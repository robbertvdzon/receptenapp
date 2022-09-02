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
class InternalIngredientTags {
  List<InternalIngredientTag> tags;
  InternalIngredientTags(this.tags);

  factory InternalIngredientTags.fromJson(Map<String, dynamic> json) => _$IngredientTagsFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagsToJson(this);
}

@JsonSerializable()
class InternalIngredientTag {
  String? tag;

  InternalIngredientTag(this.tag);

  factory InternalIngredientTag.fromJson(Map<String, dynamic> json) =>
      _$IngredientTagFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagToJson(this);
}

