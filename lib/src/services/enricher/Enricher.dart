import 'dart:convert';

import 'package:receptenapp/src/model/ingredients/v1/ingredientTags.dart';
import 'package:receptenapp/src/services/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/services/repositories/IngredientsRepository.dart';
import 'package:receptenapp/src/ui/receptenapp/ingredienttags/IngredientTagsPage.dart';
import '../../model/recipes/v1/receptTags.dart';
import '../repositories/ProductsRepository.dart';

import '../../global.dart';
import '../../model/enriched/enrichedmodels.dart';
import '../../model/ingredients/v1/ingredients.dart';
import '../../model/recipes/v1/recept.dart';
import '../repositories/RecipesRepository.dart';
import '../repositories/RecipesTagsRepository.dart';

class Enricher {
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();

  EnrichedReceptIngredient enrichtReceptIngredient(
      ReceptIngredient receptIngredient) {
    var nutritionalValues = NutritionalValues();
    return EnrichedReceptIngredient(
        receptIngredient.name,
        receptIngredient.amountGrams,
        receptIngredient.amountItems,
        nutritionalValues);
  }

  EnrichedRecept enrichRecipe(Recept recept) {
    var nutritionalValues = NutritionalValues();
    recept.ingredients.forEach((receptIngredient) {
      var ingredient = _ingredientsRepository.getIngredientByName(receptIngredient.name);
      if (ingredient!=null) {
        var productName = ingredient.nutrientName;
        if (productName!=null) {
          var product = _productsRepository.getProductByName(productName);
          double weight = 0.0;
          if (receptIngredient.amountItems!=null){
            weight = receptIngredient.amountItems!.items * ingredient.gramsPerPiece;
          }
          if (receptIngredient.amountGrams!=null){
            weight = receptIngredient.amountGrams!.grams;
          }
          nutritionalValues.kcal += weight*(product?.kcal??0)/100;
          nutritionalValues.prot += weight*(product?.prot??0)/100;
          nutritionalValues.nt += weight*(product?.nt??0)/100;
          nutritionalValues.fat += weight*(product?.fat??0)/100;
          nutritionalValues.sugar += weight*(product?.sugar??0)/100;
          nutritionalValues.na += weight*(product?.na??0)/100;
          nutritionalValues.k += weight*(product?.k??0)/100;
          nutritionalValues.fe += weight*(product?.fe??0)/100;
          nutritionalValues.mg += weight*(product?.mg??0)/100;
        }
      }
    });

    var tags = recept.tags
        .map((e) => _recipesTagsRepository.getTagByTag(e))
        .toList();


    var enrichedIngredients =
        recept.ingredients.map((e) => enrichtReceptIngredient(e)).toList();
    var result = EnrichedRecept(recept.uuid, recept.name, recept.directions,
        nutritionalValues, enrichedIngredients, tags);
    return result;
  }

  EnrichedIngredient enrichtIngredient(Ingredient ingredient) {
    var nutritionalValues = NutritionalValues();

    var productName = ingredient.nutrientName;
    if (productName!=null) {
      var product = _productsRepository.getProductByName(productName);
      nutritionalValues.kcal = product?.kcal ?? 0;
      nutritionalValues.prot = product?.prot ?? 0;
      nutritionalValues.nt = product?.nt ?? 0;
      nutritionalValues.fat = product?.fat ?? 0;
      nutritionalValues.sugar = product?.sugar ?? 0;
      nutritionalValues.na = product?.na ?? 0;
      nutritionalValues.k = product?.k ?? 0;
      nutritionalValues.fe = product?.fe ?? 0;
      nutritionalValues.mg = product?.mg ?? 0;
    }

    var tags = ingredient.tags
        .map((e) => _ingredientTagsRepository.getTagByTag(e))
        .toList();

    var recipes = _recipesRepository.getRecipes().recipes.where((element) => element.containsIngredient(ingredient.name)).toList();

    return EnrichedIngredient(ingredient.uuid, ingredient.name,ingredient.gramsPerPiece,
        ingredient.nutrientName, nutritionalValues, tags, recipes);
  }

  EnrichedIngredientTag enrichtIngredientTag(IngredientTag tag) {
    List<Ingredient> ingredients = _ingredientsRepository.getIngredients().ingredients.where((element) => element.containsTag(tag.tag)).toList();
    List<EnrichedIngredient> enrichedIngredients = ingredients.map((e) => enrichtIngredient(e)).toList();
    List<Recept?> recipes = enrichedIngredients.expand((element) => element.recipes).toSet().toList();

    return EnrichedIngredientTag(tag.tag, ingredients, recipes);
  }

  EnrichedRecipeTag enrichtRecipeTag(ReceptTag tag) {
    var recipes = _recipesRepository.getRecipes().recipes.where((element) => element.containsTag(tag.tag)).toList();

    return EnrichedRecipeTag(tag.tag, recipes);
  }

}
