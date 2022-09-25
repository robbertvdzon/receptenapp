import 'dart:convert';

import 'package:receptenapp/src/model/ingredients/v1/ingredientTags.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../model/recipes/v1/receptTags.dart';
import '../repositories/ProductsRepository.dart';

import '../GetItDependencies.dart';
import '../model/enriched/enrichedmodels.dart';
import '../model/ingredients/v1/ingredients.dart';
import '../model/recipes/v1/recept.dart';
import '../repositories/RecipesRepository.dart';
import '../repositories/RecipesTagsRepository.dart';
import '../GlobalState.dart';

class ReceptService {
  var _recipesRepository = getIt<RecipesRepository>();


  Future<void> saveRecept(Recept recept)  {
    return _recipesRepository.saveRecept(recept);
  }


}
