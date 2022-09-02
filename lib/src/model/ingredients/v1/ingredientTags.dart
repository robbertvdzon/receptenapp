import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredientTags.g.dart';

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

  IngredientTag(this.tag); //2

  factory IngredientTag.fromJson(Map<String, dynamic> json) =>
      _$IngredientTagFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagToJson(this);
}

