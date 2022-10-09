
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
  Ingredient? ingredient;
  ReceptIngredientAmount? amount = null;
  NutritionalValues nutritionalValues;

  EnrichedReceptIngredient(this.name, this.ingredient, this.amount, this.nutritionalValues);

  String toTextString() {
    if (amount!=null){
      return "${amount!.nrUnit} ${amount!.unit} ${name}";
    }
    return "unkown amount!!";
  }
}

class EnrichedIngredient {
  String uuid;
  String name;
  double gramsPerPiece;
  String? productName;
  NutritionalValues nutritionalValues;
  List<IngredientTag?> tags;
  List<Recept?> recipes;

  EnrichedIngredient(this.uuid, this.name, this.gramsPerPiece, this.productName, this.nutritionalValues, this.tags, this.recipes);
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
