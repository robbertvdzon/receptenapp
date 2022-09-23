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
  ReceptDetailsPage({Key? key, required this.title, required this.recept}) : super(key: key) {}

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
      if (event.uuid==recept.recept.uuid){
        setState(() {
          Recept? updatedRecept = recipesRepository.getReceptByUuid(recept.recept.uuid);
          if (updatedRecept!=null) {
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

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              ElevatedButton(
                child: Text('Prev'),
                onPressed: () {
                },
              ),
              SizedBox(width: 10),
              ElevatedButton(
                child: Text('Next'),
                onPressed: () {
                },
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
          body: Center(

              child:Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(label: Text('uuid:')),
                    initialValue: "${recept.recept.uuid}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Name:')),
                    initialValue: "${recept.recept.name}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Opmerking:')),
                    initialValue: "${recept.recept.remark}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Voorbereidingstijd:')),
                    initialValue: "${recept.recept.preparingTime}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Totale kooktijd:')),
                    initialValue: "${recept.recept.totalCookingTime}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Nt:')),
                    initialValue: "${recept.nutritionalValues.nt}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Kcal:')),
                    initialValue: "${recept.nutritionalValues.kcal}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Fat:')),
                    initialValue: "${recept.nutritionalValues.fat}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Ingredients:')),
                    initialValue: "${recept.ingredienten.map((e) => e?.toTextString()).join(",")}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Tags:')),
                    initialValue: "${recept.tags.map((e) => e?.tag).join(",")}",
                  ),
                ],
              )

          ))
    ;
  }

}


