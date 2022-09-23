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

class ReceptDetailsPage extends StatefulWidget {
  ReceptDetailsPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final Recept recept;
  final String title;

  @override
  State<ReceptDetailsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptDetailsPage> {
  late EnrichedRecept recept;
  var recipesRepository = getIt<RecipesRepository>();
  var enricher = getIt<Enricher>();
  var eventBus = getIt<EventBus>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Recept recept) {
    this.recept = enricher.enrichRecipe(recept);
  }

  @override
  void initState() {
    _eventStreamSub = eventBus.on<ReceptChangedEvent>().listen((event) {
      if (event.uuid == recept.recept.uuid) {
        setState(() {
          Recept? updatedRecept =
              recipesRepository.getReceptByUuid(recept.recept.uuid);
          if (updatedRecept != null) {
            recept = enricher.enrichRecipe(updatedRecept);
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
          Text(recept.recept.remark),
        ]),
        TableRow(children: [
          Text("Voorbereidingstijd"),
          Text(":"),
          Text("${recept.recept.preparingTime}"),
        ]),
        TableRow(children: [
          Text("Totale kooktijd"),
          Text(":"),
          Text("${recept.recept.totalCookingTime}"),
        ]),
        TableRow(children: [
          Text("Kcal"),
          Text(":"),
          Text("${recept.nutritionalValues.kcal}"),
        ]),
        TableRow(children: [
          Text("Vet"),
          Text(":"),
          Text("${recept.nutritionalValues.fat}"),
        ]),
        TableRow(children: [
          Text("Proteine"),
          Text(":"),
          Text("${recept.nutritionalValues.prot}"),
        ]),
        TableRow(children: [
          Text("Tags"),
          Text(":"),
          Text("${recept.tags.map((e) => e?.tag).join(",")}"),
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
              onPressed: () {},
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text('Next'),
              onPressed: () {},
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReceptEditPage(title: 'Edit', recept: recept)),
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
                    Text(recept.recept.name, style: TextStyle(fontSize: 25.0)),
                    Container(
                      alignment: Alignment.topLeft, // use aligment
                      padding: EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
                      child: Image.asset('assets/images/recept1.jpeg',
                          height: 300, width: 300, fit: BoxFit.cover),
                    ),
                    Text(''),
                    Text('Opmerkingen:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(recept.recept.remark),
                    Text(''),
                    Text('Ingredienten:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(
                        "${recept.ingredienten.map((e) => e?.toTextString()).join("\n")}"),
                    Text(''),
                    Text('Bereiding:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(recept.recept.directions),
                    Text(''),
                    Text('Details:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Container(
                      alignment: Alignment.center, // use aligment
                      padding: EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
                      child: tableWithValues(),
                    ),
                  ],
        )));
  }
}
