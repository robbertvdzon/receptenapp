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
      ..directions = json['directions'] as String
      ..remark = json['remark'] as String
      ..totalCookingTime = json['totalCookingTime'] as int
      ..preparingTime = json['preparingTime'] as int
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$ReceptToJson(Recept instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'directions': instance.directions,
      'remark': instance.remark,
      'totalCookingTime': instance.totalCookingTime,
      'preparingTime': instance.preparingTime,
      'ingredients': instance.ingredients,
      'tags': instance.tags,
    };

ReceptIngredient _$ReceptIngredientFromJson(Map<String, dynamic> json) =>
    ReceptIngredient(
      json['name'] as String,
      amountGrams: json['amountGrams'] == null
          ? null
          : ReceptIngredientAmountGrams.fromJson(
              json['amountGrams'] as Map<String, dynamic>),
      amountItems: json['amountItems'] == null
          ? null
          : ReceptIngredientAmountItems.fromJson(
              json['amountItems'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReceptIngredientToJson(ReceptIngredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amountGrams': instance.amountGrams,
      'amountItems': instance.amountItems,
    };

ReceptIngredientAmountGrams _$ReceptIngredientAmountGramsFromJson(
        Map<String, dynamic> json) =>
    ReceptIngredientAmountGrams(
      (json['grams'] as num).toDouble(),
    );

Map<String, dynamic> _$ReceptIngredientAmountGramsToJson(
        ReceptIngredientAmountGrams instance) =>
    <String, dynamic>{
      'grams': instance.grams,
    };

ReceptIngredientAmountItems _$ReceptIngredientAmountItemsFromJson(
        Map<String, dynamic> json) =>
    ReceptIngredientAmountItems(
      (json['items'] as num).toDouble(),
    );

Map<String, dynamic> _$ReceptIngredientAmountItemsToJson(
        ReceptIngredientAmountItems instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
