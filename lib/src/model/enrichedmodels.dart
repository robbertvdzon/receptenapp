
import 'ingredientTags.dart';

class EnrichedRecept {
  String uuid;
  String name;
  String directions = "";
  NutritionalValues nutritionalValues;
  List<EnrichedIngredient> ingredienten;
  EnrichedRecept(this.uuid, this.name, this.directions, this.nutritionalValues, this.ingredienten);
}

class EnrichedIngredient {
  String uuid;
  String name;
  String? nutrientName;
  NutritionalValues nutritionalValues;
  List<IngredientTag> tags;

  EnrichedIngredient(this.uuid, this.name, this.nutrientName, this.nutritionalValues, this.tags);
}

class NutritionalValues {
  String? kcal;
  String? prot;
  String? nt;
  String? fat;
  String? sugar;
  String? na;
  String? k;
  String? fe;
  String? mg;
  NutritionalValues(
    this.kcal,
    this.prot,
    this.nt,
    this.fat,
    this.sugar,
    this.na,
    this.k,
    this.fe,
    this.mg,
  );
}
