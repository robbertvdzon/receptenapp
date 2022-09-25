import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receptenapp/src/repositories/RecipesRepository.dart';
import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../events/ReceptChangedEvent.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../ingredientsapp/ingredients/IngredientDetailsPage.dart';
import 'ReceptDetailsPage.dart';
import 'package:event_bus/event_bus.dart';


class ReceptIngredientItemWidget extends StatefulWidget {
  ReceptIngredientItemWidget({Key? key, required this.ingredient})
      : super(key: key) {}

  final EnrichedReceptIngredient ingredient;

  @override
  State<ReceptIngredientItemWidget> createState() => _WidgetState(ingredient);
}

class _WidgetState extends State<ReceptIngredientItemWidget> {

  late EnrichedReceptIngredient ingredient;

  _WidgetState(EnrichedReceptIngredient ingredient) {
    this.ingredient= ingredient;
  }

  @override
  void initState() {
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
            IngredientDetailsPage(
              title: 'Ingredient',
              ingredient: ingredient.ingredient!,
            )
      )
    );
  }


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {_openForm();}, // Handle your callback
      child:
      new Text(
        ingredient.toTextString(),
      ),
    );



  }

}


