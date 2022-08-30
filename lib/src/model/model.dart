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
  String? nutrientName;
  List<Tag> tags = List.empty();

  Ingredient(this.name);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

@JsonSerializable()
class Nutrients {
  List<Nutrient> nutrients;
  Nutrients(this.nutrients);

  factory Nutrients.fromJson(Map<String, dynamic> json) => _$NutrientsFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientsToJson(this);

}


@JsonSerializable()
class Nutrient {
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
  bool? customNutrient = false;

  Nutrient(this.name);

  factory Nutrient.fromJson(Map<String, dynamic> json) =>
      _$NutrientFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientToJson(this);
}


@JsonSerializable()
class Tags {
  List<Tag> tags;
  Tags(this.tags);

  factory Tags.fromJson(Map<String, dynamic> json) => _$TagsFromJson(json);

  Map<String, dynamic> toJson() => _$TagsToJson(this);
}

@JsonSerializable()
class Tag {
  String? tag;

  Tag(this.tag);

  factory Tag.fromJson(Map<String, dynamic> json) =>
      _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}