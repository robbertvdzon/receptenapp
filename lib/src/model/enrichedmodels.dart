import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

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
  List<Tag> tags;

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
