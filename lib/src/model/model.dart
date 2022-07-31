import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

var uuid = Uuid();


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

@JsonSerializable()
class BaseIngredients {
  List<BaseIngredient> ingredienten;
  BaseIngredients(this.ingredienten);

  factory BaseIngredients.fromJson(Map<String, dynamic> json) => _$BaseIngredientsFromJson(json);

  Map<String, dynamic> toJson() => _$BaseIngredientsToJson(this);

}


@JsonSerializable()
class BaseIngredient {
  String? name;
  String? category;
  int? nevoCode;
  String? quantity;
  String? kcal;
  String? prot;
  String? nt;
  String? fat;
  String? sugar;
  String? na;
  String? k;
  String? fe;
  String? mg;
  bool? customIngredient = false;

  BaseIngredient(this.name);

  factory BaseIngredient.fromJson(Map<String, dynamic> json) =>
      _$BaseIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$BaseIngredientToJson(this);
}