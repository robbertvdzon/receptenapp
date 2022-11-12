// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recept.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipes _$RecipesFromJson(Map<String, dynamic> json) => Recipes(
      (json['recipes'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecipesToJson(Recipes instance) => <String, dynamic>{
      'recipes': instance.recipes,
    };

Recept _$ReceptFromJson(Map<String, dynamic> json) => Recept(
      (json['ingredients'] as List<dynamic>)
          .map((e) => ReceptIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String,
    )
      ..uuid = json['uuid'] as String
      ..instructions = json['instructions'] as String
      ..remark = json['remark'] as String
      ..totalCookingTime = json['totalCookingTime'] as int
      ..preparingTime = json['preparingTime'] as int
      ..dateAdded = json['dateAdded'] as int
      ..nrPersons = json['nrPersons'] as int
      ..favorite = json['favorite'] as bool
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$ReceptToJson(Recept instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'instructions': instance.instructions,
      'remark': instance.remark,
      'totalCookingTime': instance.totalCookingTime,
      'preparingTime': instance.preparingTime,
      'dateAdded': instance.dateAdded,
      'nrPersons': instance.nrPersons,
      'favorite': instance.favorite,
      'ingredients': instance.ingredients,
      'tags': instance.tags,
    };

ReceptIngredient _$ReceptIngredientFromJson(Map<String, dynamic> json) =>
    ReceptIngredient(
      json['name'] as String,
      amount: json['amount'] == null
          ? null
          : ReceptIngredientAmount.fromJson(
              json['amount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReceptIngredientToJson(ReceptIngredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
    };

ReceptIngredientAmount _$ReceptIngredientAmountFromJson(
        Map<String, dynamic> json) =>
    ReceptIngredientAmount(
      (json['nrUnit'] as num).toDouble(),
      json['unit'] as String,
    );

Map<String, dynamic> _$ReceptIngredientAmountToJson(
        ReceptIngredientAmount instance) =>
    <String, dynamic>{
      'nrUnit': instance.nrUnit,
      'unit': instance.unit,
    };
