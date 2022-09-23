import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../model/recipes/v1/recept.dart';

class UIReceptenGlobalState {
  Recept? selectedRecept = null;
  List<Recept> filteredRecipes = List.empty();

  void selectNextRecept(){
    if (selectedRecept==null) return;
    int currentIndex = filteredRecipes.indexOf(selectedRecept!);
    int newIndex = currentIndex+1;
    if (newIndex<filteredRecipes.length) {
      selectedRecept = filteredRecipes.elementAt(newIndex);
    }
    else{
      selectedRecept = filteredRecipes.last;
    }
  }

  void selectPreviousRecept(){
    if (selectedRecept==null) return;
    int currentIndex = filteredRecipes.indexOf(selectedRecept!);
    if (currentIndex==0) return;
    if (currentIndex>filteredRecipes.length) {
      selectedRecept = filteredRecipes.last;
    }
    selectedRecept = filteredRecipes.elementAt(currentIndex-1);
  }
}
