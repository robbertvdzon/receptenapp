import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/repositories/RecipesRepository.dart';
import '../../../global.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/events/ReceptChangedEvent.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/enricher/Enricher.dart';

class ReceptEditPage extends StatefulWidget {
  ReceptEditPage({Key? key, required this.title, required this.recept}) : super(key: key) {}

  final EnrichedRecept recept;
  final String title;

  @override
  State<ReceptEditPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptEditPage> {
  late EnrichedRecept recept;
  late Recept newRecept;
  var recipesRepository = getIt<RecipesRepository>();
  var enricher = getIt<Enricher>();
  var eventBus = getIt<EventBus>();

  _WidgetState(EnrichedRecept recept) {
    this.recept = recept;
    this.newRecept = recept.recept;
  }

  _saveForm() {
    recipesRepository.saveRecept(newRecept);
    eventBus.fire(ReceptChangedEvent(newRecept.uuid));
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
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
                    onChanged: (text) {
                      newRecept.name = text;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Opmerking:')),
                    initialValue: "${recept.recept.remark}",
                    onChanged: (text) {
                      newRecept.remark = text;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Voorbereidingstijd:')),
                    initialValue: "${recept.recept.preparingTime}",
                    onChanged: (text) {
                      newRecept.preparingTime = int.parse(text);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Totale kooktijd:')),
                    initialValue: "${recept.recept.totalCookingTime}",
                    onChanged: (text) {
                      newRecept.totalCookingTime = int.parse(text);
                    },
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
                  ElevatedButton(
                    child: Text('SAVE!'),
                    onPressed: () {
                      _saveForm();
                    },
                  )
                ],
              )

          ))
    ;
  }

}


