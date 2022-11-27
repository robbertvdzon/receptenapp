// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Snacks _$SnacksFromJson(Map<String, dynamic> json) => Snacks(
      (json['snacks'] as List<dynamic>)
          .map((e) => Snack.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SnacksToJson(Snacks instance) => <String, dynamic>{
      'snacks': instance.snacks,
    };

Snack _$SnackFromJson(Map<String, dynamic> json) => Snack(
      (json['ingredients'] as List<dynamic>)
          .map((e) => ReceptIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String,
    )..uuid = json['uuid'] as String;

Map<String, dynamic> _$SnackToJson(Snack instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'ingredients': instance.ingredients,
    };
