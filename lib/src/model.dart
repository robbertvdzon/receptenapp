import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class ReceptenBoek {
  List<Ingredient> ingredienten;
  List<Recept> recepten;

  ReceptenBoek(this.recepten, this.ingredienten);

  factory ReceptenBoek.fromJson(Map<String, dynamic> json) =>
      _$ReceptenBoekFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptenBoekToJson(this);
}

@JsonSerializable()
class Recept {
  String uuid = Uuid().v1();
  String name;
  List<Ingredient> ingredienten;

  Recept(this.ingredienten, this.name);

  factory Recept.fromJson(Map<String, dynamic> json) => _$ReceptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptToJson(this);
}

@JsonSerializable()
class Ingredient {
  String uuid = Uuid().v1();
  String name;

  Ingredient(this.name);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
