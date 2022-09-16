import 'package:flutter/material.dart';
import '../../../model/ingredients/v1/ingredientTags.dart';
import 'IngredientTagDetailsPage.dart';

class IngredientTagItemWidget extends StatefulWidget {
  IngredientTagItemWidget({Key? key, required this.ingredientTag})
      : super(key: key) {}

  final IngredientTag ingredientTag;

  @override
  State<IngredientTagItemWidget> createState() => _WidgetState(ingredientTag);
}

class _WidgetState extends State<IngredientTagItemWidget> {
  late IngredientTag ingredientTag;

  _WidgetState(IngredientTag ingredientTag) {
    this.ingredientTag = ingredientTag;
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              IngredientTagDetailsPage(title: 'Ingredient Tag', ingredientTag: ingredientTag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextButton(
          onPressed: () {
            _openForm();
          },
          child: new Text(ingredientTag.tag??""),
        )
      ],
    );
  }

}


