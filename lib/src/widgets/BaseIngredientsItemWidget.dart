import 'package:flutter/material.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/BaseIngriedientsRepository.dart';

class BaseIngredientsItemWidget extends StatefulWidget {
  BaseIngredientsItemWidget({Key? key, required this.ingredient}) : super(key: key) {}

  final BaseIngredient ingredient;

  @override
  State<BaseIngredientsItemWidget> createState() => _WidgetState(ingredient);
}

class _WidgetState extends State<BaseIngredientsItemWidget> {
  late BaseIngredient ingredient;
  late BaseIngredient newIngredient;
  var baseIngredientsRepository = getIt<BaseIngredientsRepository>();


  _WidgetState(BaseIngredient ingredient) {
    this.ingredient = ingredient;
    this.newIngredient = ingredient;
  }

  _saveForm(){
      print("SAVE");
      print(newIngredient.name);
      baseIngredientsRepository.loadBaseIngredients().then((value) => saveIngredient(value, newIngredient));
  }

  saveIngredient(BaseIngredients baseIngredients, BaseIngredient newIngredient) {
    baseIngredients.ingredienten.remove(ingredient);
    baseIngredients.ingredienten.where((element) => element.name==ingredient.name).forEach((element) {
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
      element.customIngredient = newIngredient.customIngredient;
    });
    baseIngredientsRepository.saveBaseIngredients(baseIngredients);



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

        TextFormField(
          decoration: InputDecoration(label:   Text('kcal:')),
          initialValue: "${ingredient.kcal}",
          onChanged: (text) {newIngredient.kcal = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('Na:')),
          initialValue: "${ingredient.na}",
          onChanged: (text) {newIngredient.na = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('k:')),
          initialValue: "${ingredient.k}",
          onChanged: (text) {newIngredient.k = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('prot:')),
          initialValue: "${ingredient.prot}",
          onChanged: (text) {newIngredient.prot = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('fat:')),
          initialValue: "${ingredient.fat}",
          onChanged: (text) {newIngredient.fat = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('fe:')),
          initialValue: "${ingredient.fe}",
          onChanged: (text) {newIngredient.fe = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('mg:')),
          initialValue: "${ingredient.mg}",
          onChanged: (text) {newIngredient.mg = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('quantity:')),
          initialValue: "${ingredient.quantity}",
          onChanged: (text) {newIngredient.quantity = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('nt:')),
          initialValue: "${ingredient.nt}",
          onChanged: (text) {newIngredient.nt = text;},
        ),

        TextFormField(
          decoration: InputDecoration(label:   Text('Suiker:')),
          initialValue: "${ingredient.sugar}",
          onChanged: (text) {newIngredient.sugar = text;},
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('Category:')),
          initialValue: "${ingredient.category}",
          onChanged: (text) {newIngredient.category = text;},
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('nevo code:')),
          initialValue: "${ingredient.nevoCode}",
        ),
        TextFormField(
          decoration: InputDecoration(label:   Text('custom field:')),
          initialValue: "${ingredient.customIngredient}",
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
