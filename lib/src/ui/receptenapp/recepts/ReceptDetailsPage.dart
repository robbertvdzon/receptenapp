import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receptenapp/src/repositories/RecipesRepository.dart';
import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../events/ReceptChangedEvent.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/Enricher.dart';
import '../../../services/ReceptService.dart';
import 'ReceptEditPage.dart';
import 'package:event_bus/event_bus.dart';

import 'ReceptIngredientItemWidget.dart';
import '../../../GlobalState.dart';

class ReceptDetailsPage extends StatefulWidget {
  ReceptDetailsPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final Recept recept;
  final String title;

  @override
  State<ReceptDetailsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptDetailsPage> {
  static const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');
  var recipesRepository = getIt<RecipesRepository>();
  var uiReceptenGlobalState = getIt<GlobalState>();

  late Recept recept;
  late EnrichedRecept enrichedRecept;
  var enricher = getIt<Enricher>();
  var eventBus = getIt<EventBus>();
  var receptService = getIt<ReceptService>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Recept recept) {
    this.enrichedRecept = enricher.enrichRecipe(recept);
    this.recept = recept;
  }

  void nextRecept() {
    recept = receptService.selectNextRecept(recept);
    this.enrichedRecept = enricher.enrichRecipe(recept);
    this.recept = recept;
    setState(() {});
  }

  void prevRecept() {
    recept = receptService.selectPreviousRecept(recept);
    this.enrichedRecept = enricher.enrichRecipe(recept);
    this.recept = recept;
    setState(() {});
  }

  void setFavorite(bool favorite){
    recept.favorite = favorite;
    recipesRepository.saveRecept(recept);
    eventBus.fire(ReceptChangedEvent(recept.uuid));
  }


  @override
  void initState() {
    _eventStreamSub = eventBus.on<ReceptChangedEvent>().listen((event) {
      if (event.uuid == enrichedRecept.recept.uuid) {
        setState(() {
          Recept? updatedRecept =
              recipesRepository.getReceptByUuid(enrichedRecept.recept.uuid);
          if (updatedRecept != null) {
            enrichedRecept = enricher.enrichRecipe(updatedRecept);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  Table tableWithValues() {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(200),
        1: FixedColumnWidth(10),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          Text("Favoriet"),
          Text(":"),
          Text("${enrichedRecept.recept.favorite}"),
        ]),
        TableRow(children: [
          Text("Voorbereidingstijd"),
          Text(":"),
          Text("${enrichedRecept.recept.preparingTime}"),
        ]),
        TableRow(children: [
          Text("Totale kooktijd"),
          Text(":"),
          Text("${enrichedRecept.recept.totalCookingTime}"),
        ]),
        TableRow(children: [
          Text("Kcal"),
          Text(":"),
          Text("${enrichedRecept.nutritionalValues.kcal}"),
        ]),
        TableRow(children: [
          Text("Vet"),
          Text(":"),
          Text("${enrichedRecept.nutritionalValues.fat}"),
        ]),
        TableRow(children: [
          Text("Proteine"),
          Text(":"),
          Text("${enrichedRecept.nutritionalValues.prot}"),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String? swipeDirection;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GestureDetector(
            onPanUpdate: (details) {
              swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
            },
            onPanEnd: (details) {
              if (swipeDirection == null) {
                return;
              }
              if (swipeDirection == 'left') {
                nextRecept();
              }
              if (swipeDirection == 'right') {
                prevRecept();
              }
            },
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(enrichedRecept.recept.name,
                    style: TextStyle(fontSize: 25.0)),
                Container(
                  alignment: Alignment.topLeft, // use aligment
                  padding:
                      EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
                  child: Image.asset('assets/images/recept1.jpeg',
                      height: 300, width: 300, fit: BoxFit.cover),
                ),
                if (recept.favorite) new Icon(star, size: 20.0, color: Colors.yellow),
                Text(''),
                Text('Opmerkingen:',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                Text(enrichedRecept.recept.remark),
                Text(''),
                Text('Ingredienten:',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ]+
                  enrichedRecept.ingredienten.map((item) {
                    return Container(
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints.expand(
                              height: 20.0,
                            ),
                            alignment: Alignment.topLeft,
                            child:
                             ReceptIngredientItemWidget(
                                 ingredient: item, key: ObjectKey(item)),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                    );
                  }).toList()+[
                Text(''),
                Text('Bereiding:',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                Text(enrichedRecept.recept.directions),
                Text(''),
                Text('Details:',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                Container(
                  alignment: Alignment.center, // use aligment
                  padding:
                      EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
                  child: tableWithValues(),
                ),
                Text(''),
                Text('Tags:',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                Text("${enrichedRecept.tags.map((e) => e?.tag).join("\n")}"),
                Text(''),
                ElevatedButton(
                  child: Text('Bewerk'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReceptEditPage(
                              title: 'Edit', recept: enrichedRecept)),
                    );
                  },
                ),
                Text(''),
                ElevatedButton(
                  child: Text('Voeg toe aan planner'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReceptEditPage(
                              title: 'Edit', recept: enrichedRecept)),
                    );
                  },
                ),
                Text(''),
                if (!recept.favorite) ElevatedButton(
                  child: Text('Voeg toe aan favorieten'),
                  onPressed: () {
                    setFavorite(true);
                  },
                ),
                if (recept.favorite) ElevatedButton(
                  child: Text('Verwijder van favorieten'),
                  onPressed: () {
                    setFavorite(false);
                  },
                ),
              ],
            ))));
  }
}
