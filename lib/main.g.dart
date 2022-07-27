// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceptenBoek _$ReceptenBoekFromJson(Map<String, dynamic> json) => ReceptenBoek(
      (json['recepten'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['ingredienten'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReceptenBoekToJson(ReceptenBoek instance) =>
    <String, dynamic>{
      'ingredienten': instance.ingredienten,
      'recepten': instance.recepten,
    };

Recept _$ReceptFromJson(Map<String, dynamic> json) => Recept(
      (json['ingredienten'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String,
    )..uuid = json['uuid'] as String;

Map<String, dynamic> _$ReceptToJson(Recept instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'ingredienten': instance.ingredienten,
    };

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      json['name'] as String,
    )..uuid = json['uuid'] as String;

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
    };
