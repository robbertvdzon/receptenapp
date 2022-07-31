import 'package:flutter/material.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/BaseIngriedientsRepository.dart';

class NutrientItemWidget extends StatefulWidget {
  NutrientItemWidget({Key? key, required this.nutrient}) : super(key: key) {}

  final Nutrient nutrient;

  @override
  State<NutrientItemWidget> createState() => _WidgetState(nutrient);
}

class _WidgetState extends State<NutrientItemWidget> {
  late Nutrient nutrient;
  late Nutrient newNutrient;
  var baseIngredientsRepository = getIt<NutrientsRepository>();


  _WidgetState(Nutrient ingredient) {
    this.nutrient = ingredient;
    this.newNutrient = ingredient;
  }

  _saveForm(){
      baseIngredientsRepository.loadNutrients().then((value) => saveNutrient(value, newNutrient));
  }

  saveNutrient(Nutrients baseIngredients, Nutrient newIngredient) {
    // baseIngredients.nutrients.remove(nutrient);
    baseIngredients.nutrients.where((element) => element.name==nutrient.name).forEach((element) {
      element.name = newIngredient.name;
      element.quantity = newIngredient.quantity;
      element.category = newIngredient.category;
      element.nevoCode = newIngredient.nevoCode;
      element.kcal = newIngredient.kcal;
      element.prot = newIngredient.prot;
      element.nt = newIngredient.nt;
      element.fat = newIngredient.fat;
      element.sugar = newIngredient.sugar;
      element.na = newIngredient.na;
      element.k = newIngredient.k;
      element.fe = newIngredient.fe;
      element.mg = newIngredient.mg;
      element.customNutrient = newIngredient.customNutrient;
    });
    baseIngredientsRepository.saveNutrients(baseIngredients);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(label:   Text('Name:')),
          initialValue: "${nutrient.name}",
          onChanged: (text) {newNutrient.name = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('kcal:')),
          initialValue: "${nutrient.kcal}",
          onChanged: (text) {newNutrient.kcal = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('Na:')),
          initialValue: "${nutrient.na}",
          onChanged: (text) {newNutrient.na = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('k:')),
          initialValue: "${nutrient.k}",
          onChanged: (text) {newNutrient.k = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('prot:')),
          initialValue: "${nutrient.prot}",
          onChanged: (text) {newNutrient.prot = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('fat:')),
          initialValue: "${nutrient.fat}",
          onChanged: (text) {newNutrient.fat = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('fe:')),
          initialValue: "${nutrient.fe}",
          onChanged: (text) {newNutrient.fe = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('mg:')),
          initialValue: "${nutrient.mg}",
          onChanged: (text) {newNutrient.mg = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('quantity:')),
          initialValue: "${nutrient.quantity}",
          onChanged: (text) {newNutrient.quantity = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('nt:')),
          initialValue: "${nutrient.nt}",
          onChanged: (text) {newNutrient.nt = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('Suiker:')),
          initialValue: "${nutrient.sugar}",
          onChanged: (text) {newNutrient.sugar = text;},
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('Category:')),
          initialValue: "${nutrient.category}",
          onChanged: (text) {newNutrient.category = text;},
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('nevo code:')),
          initialValue: "${nutrient.nevoCode}",
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('custom field:')),
          initialValue: "${nutrient.customNutrient}",
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
