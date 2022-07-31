// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

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

BaseIngredients _$BaseIngredientsFromJson(Map<String, dynamic> json) =>
    BaseIngredients(
      (json['ingredienten'] as List<dynamic>)
          .map((e) => BaseIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BaseIngredientsToJson(BaseIngredients instance) =>
    <String, dynamic>{
      'ingredienten': instance.ingredienten,
    };

BaseIngredient _$BaseIngredientFromJson(Map<String, dynamic> json) =>
    BaseIngredient(
      json['name'] as String?,
    )
      ..category = json['category'] as String?
      ..nevoCode = json['nevoCode'] as String?
      ..quantity = json['quantity'] as String?
      ..kcal = json['kcal'] as String?
      ..prot = json['prot'] as String?
      ..nt = json['nt'] as String?
      ..fat = json['fat'] as String?
      ..sugar = json['sugar'] as String?
      ..na = json['na'] as String?
      ..k = json['k'] as String?
      ..fe = json['fe'] as String?
      ..mg = json['mg'] as String?
      ..customIngredient = json['customIngredient'] as bool?;

Map<String, dynamic> _$BaseIngredientToJson(BaseIngredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'nevoCode': instance.nevoCode,
      'quantity': instance.quantity,
      'kcal': instance.kcal,
      'prot': instance.prot,
      'nt': instance.nt,
      'fat': instance.fat,
      'sugar': instance.sugar,
      'na': instance.na,
      'k': instance.k,
      'fe': instance.fe,
      'mg': instance.mg,
      'customIngredient': instance.customIngredient,
    };
