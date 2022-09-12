import 'dart:convert';

import 'package:receptenapp/src/services/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/services/repositories/IngredientsRepository.dart';
import 'package:receptenapp/src/ui/receptenapp/ingredienttags/IngredientTagsPage.dart';
import '../repositories/ProductsRepository.dart';

import '../../global.dart';
import '../../model/enriched/enrichedmodels.dart';
import '../../model/ingredients/v1/ingredients.dart';
import '../../model/recipes/v1/recept.dart';

class Enricher {
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();

  EnrichedReceptIngredient enrichtReceptIngredient(
      ReceptIngredient receptIngredient) {
    var nutritionalValues = NutritionalValues();
    return EnrichedReceptIngredient(
        receptIngredient.name,
        receptIngredient.amountGrams,
        receptIngredient.amountItems,
        nutritionalValues);
  }

  EnrichedRecept? enrichRecipe(Recept recept) {
    var nutritionalValues = NutritionalValues();
    recept.ingredients.forEach((receptIngredient) {
      var ingredient = _ingredientsRepository.getIngredientByName(receptIngredient.name);
      if (ingredient!=null) {
        var productName = ingredient.nutrientName;
        if (productName!=null) {
          var product = _productsRepository.getProductByName(productName);
        }
      }
    });

    var enrichedIngredients =
        recept.ingredients.map((e) => enrichtReceptIngredient(e)).toList();
    var result = EnrichedRecept(recept.uuid, recept.name, recept.directions,
        nutritionalValues, enrichedIngredients);
    return result;
  }

  EnrichedIngredient enrichtIngredient(Ingredient ingredient) {
    var nutritionalValues = NutritionalValues();
    var tags = ingredient.tags
        .map((e) => _ingredientTagsRepository.getTagByTag(e))
        .toList();

    return EnrichedIngredient(ingredient.uuid, ingredient.name,
        ingredient.nutrientName, nutritionalValues, tags);
  }
}
