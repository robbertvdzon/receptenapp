import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/repositories/RecipesRepository.dart';
import '../../../global.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/events/ReceptChangedEvent.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/enricher/Enricher.dart';
import 'ReceptEditPage.dart';
import 'package:event_bus/event_bus.dart';

import 'UIRecepenGlobalState.dart';

class ReceptDetailsPage extends StatefulWidget {
  ReceptDetailsPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final Recept recept;
  final String title;

  @override
  State<ReceptDetailsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptDetailsPage> {
  var recipesRepository = getIt<RecipesRepository>();
  var uiReceptenGlobalState = getIt<UIReceptenGlobalState>();

  late Recept recept;
  late EnrichedRecept enrichedRecept;
  var enricher = getIt<Enricher>();
  var eventBus = getIt<EventBus>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Recept recept) {
    this.enrichedRecept = enricher.enrichRecipe(recept);
    this.recept = recept;
  }

  void nextRecept() {
    uiReceptenGlobalState.selectedRecept = recept;
    uiReceptenGlobalState.selectNextRecept();
    Recept? newRecept = uiReceptenGlobalState.selectedRecept;
    if (newRecept != null) {
      this.enrichedRecept = enricher.enrichRecipe(newRecept);
      this.recept = newRecept;
      setState(() {});
    }
  }

  void prevRecept() {
    uiReceptenGlobalState.selectedRecept = recept;
    uiReceptenGlobalState.selectPreviousRecept();
    Recept? newRecept = uiReceptenGlobalState.selectedRecept;
    if (newRecept != null) {
      this.enrichedRecept = enricher.enrichRecipe(newRecept);
      this.recept = newRecept;
      setState(() {});
    }
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
          Text("Opmerking"),
          Text(":"),
          Text(enrichedRecept.recept.remark),
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
        TableRow(children: [
          Text("Tags"),
          Text(":"),
          Text("${enrichedRecept.tags.map((e) => e?.tag).join(",")}"),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            ElevatedButton(
              child: Text('Prev'),
              onPressed: () {
                prevRecept();
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text('Next'),
              onPressed: () {
                nextRecept();
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceptEditPage(
                          title: 'Edit', recept: enrichedRecept)),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(enrichedRecept.recept.name, style: TextStyle(fontSize: 25.0)),
            Container(
              alignment: Alignment.topLeft, // use aligment
              padding: EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
              child: Image.asset('assets/images/recept1.jpeg',
                  height: 300, width: 300, fit: BoxFit.cover),
            ),
            Text(''),
            Text('Opmerkingen:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Text(enrichedRecept.recept.remark),
            Text(''),
            Text('Ingredienten:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Text(
                "${enrichedRecept.ingredienten.map((e) => e?.toTextString()).join("\n")}"),
            Text(''),
            Text('Bereiding:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Text(enrichedRecept.recept.directions),
            Text(''),
            Text('Details:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Container(
              alignment: Alignment.center, // use aligment
              padding: EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
              child: tableWithValues(),
            ),
          ],
        )));
  }
}
