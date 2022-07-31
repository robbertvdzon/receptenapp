import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/ReceptenRepository.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/BaseIngriedientsRepository.dart';

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
      receptenRepository.loadReceptenbook().then((value) => saveNutrient(value, newIngredient));
  }

  saveNutrient(ReceptenBoek receptenBoek, Ingredient newIngredient) {
    // receptenBoek.ingredienten.remove(ingredient);
    receptenBoek.ingredienten.where((element) => element.name==ingredient.name).forEach((element) {
      element.name = newIngredient.name;
    });
    receptenRepository.saveReceptenBoek(receptenBoek);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(label:   Text('Name:')),
          initialValue: "${ingredient.name}",
          onChanged: (text) {newIngredient.name = text;},
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
