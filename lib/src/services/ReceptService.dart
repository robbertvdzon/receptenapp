import 'dart:convert';

import 'package:receptenapp/src/model/ingredients/v1/ingredientTags.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../model/recipes/v1/receptTags.dart';
import '../repositories/ProductsRepository.dart';

import '../global.dart';
import '../model/enriched/enrichedmodels.dart';
import '../model/ingredients/v1/ingredients.dart';
import '../model/recipes/v1/recept.dart';
import '../repositories/RecipesRepository.dart';
import '../repositories/RecipesTagsRepository.dart';
import '../ui/UIRecepenGlobalState.dart';

class ReceptService {
  var _state = getIt<UIReceptenGlobalState>();

  Recept selectNextRecept(Recept recept){
    int currentIndex = _state.filteredRecipes.indexOf(recept);
    int newIndex = currentIndex+1;
    if (newIndex<_state.filteredRecipes.length) {
      return _state.filteredRecipes.elementAt(newIndex);
    }
    else{
      return _state.filteredRecipes.last;
    }
  }

  Recept selectPreviousRecept(Recept recept){
    int currentIndex = _state.filteredRecipes.indexOf(recept);
    if (currentIndex==0) return recept;
    if (currentIndex>_state.filteredRecipes.length) {
      return _state.filteredRecipes.last;
    }
    return _state.filteredRecipes.elementAt(currentIndex-1);
  }

}
