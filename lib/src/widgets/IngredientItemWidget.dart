import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/ReceptenRepository.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/NutrientsRepository.dart';

class IngredientItemWidget extends StatefulWidget {
  IngredientItemWidget({Key? key, required this.ingredient}) : super(key: key) {}

  final Ingredient ingredient;

  @override
  State<IngredientItemWidget> createState() => _WidgetState(ingredient);
}

class _WidgetState extends State<IngredientItemWidget> {
  late Ingredient ingredient;
  late Ingredient newIngredient;
  var receptenRepository = getIt<ReceptenRepository>();


  _WidgetState(Ingredient ingredient) {
    this.ingredient = ingredient;
    this.newIngredient = ingredient;
  }

  _saveForm(){
      receptenRepository.loadReceptenbook().then((value) => saveIngredient(value, newIngredient));
  }

  saveIngredient(ReceptenBoek receptenBoek, Ingredient newIngredient) {
    // receptenBoek.ingredienten.remove(ingredient);
    receptenBoek.ingredienten.where((element) => element.uuid==ingredient.uuid).forEach((element) {
      element.name = newIngredient.name;
      element.nutrientName = newIngredient.nutrientName;
    });
    receptenRepository.saveReceptenBoek(receptenBoek);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(label:   Text('uuid:')),
          initialValue: "${ingredient.uuid}",
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('Name:')),
          initialValue: "${ingredient.name}",
          onChanged: (text) {newIngredient.name = text;},
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('Voedingsmiddel:')),
          initialValue: "${ingredient.nutrientName}",
          onChanged: (text) {newIngredient.nutrientName = text;},
        ),

        ElevatedButton(
          child: Text('SAVE'),
          onPressed: () {
            _saveForm();
          },
        )
      ],
    );
  }



}
