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
  String? productName;
  double gramsPerPiece = 0;
  List<String> tags = List.empty();

  Ingredient(this.name);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  bool containsTag(String? tag) {
    return this.tags.contains(tag);
  }

  String getDisplayProductName() {
    if (productName==null) return "";
    return "[$productName]";
  }
}

@JsonSerializable()
class InternalIngredientTags {
  List<InternalIngredientTag> tags;
  InternalIngredientTags(this.tags);

  factory InternalIngredientTags.fromJson(Map<String, dynamic> json) => _$InternalIngredientTagsFromJson(json);

  Map<String, dynamic> toJson() => _$InternalIngredientTagsToJson(this);
}

@JsonSerializable()
class InternalIngredientTag {
  String? tag;

  InternalIngredientTag(this.tag);

  factory InternalIngredientTag.fromJson(Map<String, dynamic> json) =>
      _$InternalIngredientTagFromJson(json);

  Map<String, dynamic> toJson() => _$InternalIngredientTagToJson(this);
}

