
import '../ingredients/v1/ingredientTags.dart';
import '../recipes/v1/recept.dart';

class EnrichedRecept {
  String uuid;
  String name;
  String directions = "";
  NutritionalValues nutritionalValues;
  List<EnrichedReceptIngredient> ingredienten;
  EnrichedRecept(this.uuid, this.name, this.directions, this.nutritionalValues, this.ingredienten);
}

class EnrichedReceptIngredient {
  String name;
  ReceptIngredientAmountGrams? amountGrams = null;
  var amountItems = null;
  NutritionalValues nutritionalValues;

  EnrichedReceptIngredient(this.name, this.amountGrams, this.amountItems, this.nutritionalValues);
}

class EnrichedIngredient {
  String uuid;
  String name;
  String? nutrientName;
  NutritionalValues nutritionalValues;
  List<IngredientTag?> tags;

  EnrichedIngredient(this.uuid, this.name, this.nutrientName, this.nutritionalValues, this.tags);
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
