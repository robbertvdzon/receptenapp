import 'package:flutter/material.dart';
import '../../../model/ingredients/v1/ingredientTags.dart';

class IngredientTagDetailsPage extends StatefulWidget {
  IngredientTagDetailsPage({Key? key, required this.title, required this.ingredientTag}) : super(key: key) {}

  final IngredientTag ingredientTag;
  final String title;

  @override
  State<IngredientTagDetailsPage> createState() => _WidgetState(ingredientTag);
}

class _WidgetState extends State<IngredientTagDetailsPage> {
  late IngredientTag ingredientTag;

  _WidgetState(IngredientTag ingredientTag) {
    this.ingredientTag = ingredientTag;
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
                    decoration: InputDecoration(label: Text('tag:')),
                    initialValue: "${ingredientTag.tag}",
                  ),

                ],
              )

          ))
    ;
  }

}


