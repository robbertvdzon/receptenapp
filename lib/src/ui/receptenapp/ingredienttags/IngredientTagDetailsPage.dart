import 'package:flutter/material.dart';
import '../../../global.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/ingredients/v1/ingredientTags.dart';
import '../../../services/enricher/Enricher.dart';

class IngredientTagDetailsPage extends StatefulWidget {
  IngredientTagDetailsPage({Key? key, required this.title, required this.ingredientTag}) : super(key: key) {}

  final IngredientTag ingredientTag;
  final String title;

  @override
  State<IngredientTagDetailsPage> createState() => _WidgetState(ingredientTag);
}

class _WidgetState extends State<IngredientTagDetailsPage> {
  late EnrichedIngredientTag ingredientTag;
  var enricher = getIt<Enricher>();

  _WidgetState(IngredientTag ingredientTag) {
    this.ingredientTag = enricher.enrichtIngredientTag(ingredientTag);
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
                  TextFormField(
                    decoration: InputDecoration(label: Text('ingredients:')),
                    initialValue: "${ingredientTag.ingredients.map((e) => e?.name).join(",")}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('recipes:')),
                    initialValue: "${ingredientTag.recipes.map((e) => e?.name).join(",")}",
                  ),

                ],
              )

          ))
    ;
  }

}


