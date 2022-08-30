import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/NutrientsRepository.dart';

class ReceptDetailsPage extends StatefulWidget {
  ReceptDetailsPage({Key? key, required this.title, required this.recept}) : super(key: key) {}

  final Recept recept;
  final String title;

  @override
  State<ReceptDetailsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptDetailsPage> {
  late Recept recept;
  late Recept newRecept;
  var recipesRepository = getIt<RecipesRepository>();

  _WidgetState(Recept recept) {
    this.recept = recept;
    this.newRecept = recept;
  }

  _saveForm() {
    recipesRepository
        .loadRecipes()
        .then((value) => saveRecept(value, newRecept));
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


