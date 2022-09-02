import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredients.g.dart';

var uuid = Uuid();

@JsonSerializable()
class Ingredients {
  List<Ingredient> ingredients;
  Ingredients(this.ingredients);

  factory Ingredients.fromJson(Map<String, dynamic> json) => _$IngredientsFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientsToJson(this);
}

@JsonSerializable()
class Ingredient {
  String uuid = Uuid().v1();
  String name;
  String? nutrientName;
  int gramsPerPiece = 0;
  List<String> tags = List.empty();

  Ingredient(this.name);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

@JsonSerializable()
class IngredientTags {
  List<IngredientTag> tags;
  IngredientTags(this.tags);

  factory IngredientTags.fromJson(Map<String, dynamic> json) => _$IngredientTagsFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagsToJson(this);
}

@JsonSerializable()
class IngredientTag {
  String? tag;

  IngredientTag(this.tag);

  factory IngredientTag.fromJson(Map<String, dynamic> json) =>
      _$IngredientTagFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagToJson(this);
}

