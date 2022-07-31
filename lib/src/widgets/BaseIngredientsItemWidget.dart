import 'package:flutter/material.dart';
import '../model/model.dart';

class BaseIngredientsItemWidget extends StatefulWidget {
  BaseIngredientsItemWidget({Key? key, required this.ingredient}) : super(key: key) {}

  final BaseIngredient ingredient;

  @override
  State<BaseIngredientsItemWidget> createState() => _WidgetState(ingredient);
}

class _WidgetState extends State<BaseIngredientsItemWidget> {
  late BaseIngredient ingredient;
  late BaseIngredient newIngredient;

  _WidgetState(BaseIngredient ingredient) {
    this.ingredient = ingredient;
    this.newIngredient = ingredient;
  }

  void _saveForm(){
      print("SAVE");
      print(newIngredient.name);
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
