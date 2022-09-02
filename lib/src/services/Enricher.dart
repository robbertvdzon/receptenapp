import 'dart:convert';

import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/ProductsRepository.dart';

import '../global.dart';
import '../model/enriched/enrichedmodels.dart';
import '../model/ingredients/v1/ingredients.dart';
import '../model/recipes/v1/recept.dart';

class Enricher {

  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();

  EnrichedRecept? enrichRecipe(Recept recept) {
    // _ingredientsRepository.loadIngredients().then((value) => test(value));

    return null;
  }

  test(Ingredients value) {}


}

