import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../model/recipes/v1/recept.dart';

class UIReceptenGlobalState {
  List<Recept> filteredRecipes = List.empty();

  Recept selectNextRecept(Recept recept){
    int currentIndex = filteredRecipes.indexOf(recept);
    int newIndex = currentIndex+1;
    if (newIndex<filteredRecipes.length) {
      return filteredRecipes.elementAt(newIndex);
    }
    else{
      return filteredRecipes.last;
    }
  }

  Recept selectPreviousRecept(Recept recept){
    int currentIndex = filteredRecipes.indexOf(recept);
    if (currentIndex==0) return recept;
    if (currentIndex>filteredRecipes.length) {
      return filteredRecipes.last;
    }
    return filteredRecipes.elementAt(currentIndex-1);
  }
}
