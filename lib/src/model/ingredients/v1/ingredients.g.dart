// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredients.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredients _$IngredientsFromJson(Map<String, dynamic> json) => Ingredients(
      (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IngredientsToJson(Ingredients instance) =>
    <String, dynamic>{
      'ingredients': instance.ingredients,
    };

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      json['name'] as String,
    )
      ..uuid = json['uuid'] as String
      ..nutrientName = json['nutrientName'] as String?
      ..gramsPerPiece = json['gramsPerPiece'] as int
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'nutrientName': instance.nutrientName,
      'gramsPerPiece': instance.gramsPerPiece,
      'tags': instance.tags,
    };

IngredientTags _$IngredientTagsFromJson(Map<String, dynamic> json) =>
    IngredientTags(
      (json['tags'] as List<dynamic>)
          .map((e) => IngredientTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IngredientTagsToJson(IngredientTags instance) =>
    <String, dynamic>{
      'tags': instance.tags,
    };

IngredientTag _$IngredientTagFromJson(Map<String, dynamic> json) =>
    IngredientTag(
      json['tag'] as String?,
    );

Map<String, dynamic> _$IngredientTagToJson(IngredientTag instance) =>
    <String, dynamic>{
      'tag': instance.tag,
    };
