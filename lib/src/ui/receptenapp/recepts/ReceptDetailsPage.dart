import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/repositories/RecipesRepository.dart';
import '../../../global.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/enricher/Enricher.dart';

class ReceptDetailsPage extends StatefulWidget {
  ReceptDetailsPage({Key? key, required this.title, required this.recept}) : super(key: key) {}

  final Recept recept;
  final String title;

  @override
  State<ReceptDetailsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptDetailsPage> {
  late EnrichedRecept recept;
  late Recept newRecept;
  var recipesRepository = getIt<RecipesRepository>();
  var enricher = getIt<Enricher>();

  _WidgetState(Recept recept) {
    this.recept = enricher.enrichRecipe(recept);
    this.newRecept = recept;
  }

  _saveForm() {
    recipesRepository.saveRecept(newRecept);
  }

  saveRecept(Recipes recipes, Recept newRecept) {
    // receptenBoek.recepten.remove(recept);
    recipes.recipes
        .where((element) => element.uuid == recept.uuid)
        .forEach((element) {
      element.name = newRecept.name;
    });
    recipesRepository.saveRecipes(recipes);
  }

  @override
  Widget build(BuildContext context) {

    /*
    Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
     */

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
                    initialValue: "${recept.uuid}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Name:')),
                    initialValue: "${recept.name}",
                    onChanged: (text) {
                      newRecept.name = text;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Opmerking:')),
                    initialValue: "${recept.remarks}",
                    onChanged: (text) {
                      newRecept.remark = text;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Voorbereidingstijd:')),
                    initialValue: "${recept.preparingTime}",
                    onChanged: (text) {
                      newRecept.preparingTime = int.parse(text);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Totale kooktijd:')),
                    initialValue: "${recept.totalCookingTime}",
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
                  // TextFormField(
                  //   decoration: InputDecoration(label: Text('Voedingsmiddel:')),
                  //   initialValue: "${recept.nutrientName}",
                  //   onChanged: (text) {
                  //     newRecept.nutrientName = text;
                  //   },
                  // ),
                  // DropdownButton<String>(
                  //   value: "${recept.nutrientName??''}",
                  //   icon: const Icon(Icons.arrow_downward),
                  //   elevation: 16,
                  //   // style: const TextStyle(color: Colors.deepPurple),
                  //   underline: Container(
                  //     height: 2,
                  //     // color: Colors.deepPurpleAccent,
                  //   ),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       newRecept.nutrientName = newValue;
                  //     });
                  //   },
                  //   items: buildList(),
                  // ),

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


