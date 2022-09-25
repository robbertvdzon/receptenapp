import 'package:flutter/material.dart';
import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/ingredients/v1/ingredientTags.dart';
import '../../../services/Enricher.dart';

class IngredientTagDetailsPage extends StatefulWidget {
  IngredientTagDetailsPage({Key? key, required this.title, required this.ingredientTag}) : super(key: key) {}

  final IngredientTag ingredientTag;
  final String title;

  @override
  State<IngredientTagDetailsPage> createState() => _WidgetState(ingredientTag);
}

class _WidgetState extends State<IngredientTagDetailsPage> {
  late EnrichedIngredientTag _ingredientTag;
  var _enricher = getIt<Enricher>();

  _WidgetState(IngredientTag ingredientTag) {
    this._ingredientTag = _enricher.enrichtIngredientTag(ingredientTag);
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
                    initialValue: "${_ingredientTag.tag}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('ingredients:')),
                    initialValue: "${_ingredientTag.ingredients.map((e) => e?.name).join(",")}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('recipes:')),
                    initialValue: "${_ingredientTag.recipes.map((e) => e?.name).join(",")}",
                  ),

                ],
              )

          ))
    ;
  }

}


