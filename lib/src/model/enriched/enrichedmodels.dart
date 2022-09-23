
import 'package:receptenapp/src/model/recipes/v1/receptTags.dart';

import '../ingredients/v1/ingredientTags.dart';
import '../ingredients/v1/ingredients.dart';
import '../recipes/v1/recept.dart';

class EnrichedRecept {
  Recept recept;
  NutritionalValues nutritionalValues;
  List<EnrichedReceptIngredient> ingredienten;
  List<ReceptTag?> tags;
  EnrichedRecept(this.recept, this.nutritionalValues, this.ingredienten, this.tags);
}

class EnrichedReceptIngredient {
  String name;
  ReceptIngredientAmountGrams? amountGrams = null;
  ReceptIngredientAmountItems? amountItems = null;
  NutritionalValues nutritionalValues;

  EnrichedReceptIngredient(this.name, this.amountGrams, this.amountItems, this.nutritionalValues);

  String toTextString() {
    if (amountGrams!=null){
      return "${amountGrams!.grams} gram ${name}";
    }
    if (amountItems!=null){
      return "${amountItems!.items} ${name}(s)";
    }
    return "unkown amount!!";
  }
}

class EnrichedIngredient {
  String uuid;
  String name;
  double gramsPerPiece;
  String? nutrientName;
  NutritionalValues nutritionalValues;
  List<IngredientTag?> tags;
  List<Recept?> recipes;

  EnrichedIngredient(this.uuid, this.name, this.gramsPerPiece, this.nutrientName, this.nutritionalValues, this.tags, this.recipes);
}

class EnrichedIngredientTag {
  String? tag;
  List<Ingredient> ingredients;
  List<Recept?> recipes;

  EnrichedIngredientTag(this.tag, this.ingredients , this.recipes);
}

class EnrichedRecipeTag {
  String? tag;
  List<Recept?> recipes;

  EnrichedRecipeTag(this.tag, this.recipes);
}

class NutritionalValues {
  double kcal = 0;
  double prot = 0;
  double nt = 0;
  double fat = 0;
  double sugar = 0;
  double na = 0;
  double k = 0;
  double fe = 0;
  double mg = 0;
}
