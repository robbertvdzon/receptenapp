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

InternalIngredientTags _$InternalIngredientTagsFromJson(
        Map<String, dynamic> json) =>
    InternalIngredientTags(
      (json['tags'] as List<dynamic>)
          .map((e) => InternalIngredientTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InternalIngredientTagsToJson(
        InternalIngredientTags instance) =>
    <String, dynamic>{
      'tags': instance.tags,
    };

InternalIngredientTag _$InternalIngredientTagFromJson(
        Map<String, dynamic> json) =>
    InternalIngredientTag(
      json['tag'] as String?,
    );

Map<String, dynamic> _$InternalIngredientTagToJson(
        InternalIngredientTag instance) =>
    <String, dynamic>{
      'tag': instance.tag,
    };
