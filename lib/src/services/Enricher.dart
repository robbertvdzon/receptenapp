import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:receptenapp/src/model/ingredients/v1/ingredientTags.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../model/recipes/v1/receptTags.dart';

import '../GetItDependencies.dart';
import '../model/enriched/enrichedmodels.dart';
import '../model/ingredients/v1/ingredients.dart';
import '../model/recipes/v1/recept.dart';
import '../repositories/RecipesRepository.dart';
import '../repositories/RecipesTagsRepository.dart';
import 'ProductsService.dart';

class Enricher {
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _productsService = getIt<ProductsService>();

  EnrichedReceptIngredient enrichtReceptIngredient(
      ReceptIngredient receptIngredient) {
    var nutritionalValues = NutritionalValues();
    Ingredient? ingredient = _ingredientsRepository.getIngredientByName(receptIngredient.name);

    return EnrichedReceptIngredient(
        receptIngredient,
        receptIngredient.name,
        ingredient,
        receptIngredient.amount,
        nutritionalValues);
  }

  EnrichedRecept enrichRecipe(Recept recept) {
    print("enrich "+recept.name);
    var nutritionalValues = NutritionalValues();
    recept.ingredients.forEach((receptIngredient) {
      var ingredient = _ingredientsRepository.getIngredientByName(receptIngredient.name);
      if (ingredient!=null) {
        var productName = ingredient.productName;
        if (productName!=null) {
          var product = _productsService.getProductByName(productName);
          double weight = 0.0;
          if (receptIngredient.amount!=null) {
            // TODO: CALCULATE REAL WEIGHT BASED ON UNIT TYPE
            weight = receptIngredient.amount!.nrUnit * ingredient.gramsPerPiece;
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
    var result = EnrichedRecept(recept,nutritionalValues, enrichedIngredients, tags);
    return result;
  }

  EnrichedIngredient enrichtIngredient(Ingredient ingredient) {
    var nutritionalValues = NutritionalValues();

    var productName = ingredient.productName;
    if (productName!=null) {
      var product = _productsService.getProductByName(productName);
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
        ingredient.productName, nutritionalValues, tags, recipes);
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

  Image getImage(String? origBase64String) {
    if (origBase64String == null || origBase64String.isEmpty) {
      var defaultImage =
      '''iVBORw0KGgoAAAANSUhEUgAAAFAAAABQCAYAAACOEfKtAAAACXBIWXMAAC4jAAAuIwF4pT92AAAE9GlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNy4xLWMwMDAgNzkuOWNjYzRkZTkzLCAyMDIyLzAzLzE0LTE0OjA3OjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjMuMyAoTWFjaW50b3NoKSIgeG1wOkNyZWF0ZURhdGU9IjIwMjItMTEtMDZUMTQ6MTE6NDErMDE6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDIyLTExLTA2VDE0OjE4OjI2KzAxOjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIyLTExLTA2VDE0OjE4OjI2KzAxOjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpmNDIwZWI5YS1kM2VmLTRhMTYtOWJiMi05YWQ0NThiNTQzZDIiIHhtcE1NOkRvY3VtZW50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''';
      var image = Image.memory(base64Decode(defaultImage));
      return image;
    }
    var image = Image.memory(base64Decode(origBase64String));
    return image;
  }

}
