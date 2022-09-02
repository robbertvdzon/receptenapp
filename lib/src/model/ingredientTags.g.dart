// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredientTags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
