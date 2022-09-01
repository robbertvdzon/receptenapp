// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

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
      (json['ingredienten'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String,
    )
      ..uuid = json['uuid'] as String
      ..directions = json['directions'] as String
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$ReceptToJson(Recept instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'directions': instance.directions,
      'ingredienten': instance.ingredienten,
      'tags': instance.tags,
    };

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
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'nutrientName': instance.nutrientName,
      'tags': instance.tags,
    };

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'products': instance.products,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['name'] as String?,
    )
      ..category = json['category'] as String?
      ..nevoCode = json['nevoCode'] as int?
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
      ..customNutrient = json['customNutrient'] as bool?;

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
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
      'customNutrient': instance.customNutrient,
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

ReceptTags _$ReceptTagsFromJson(Map<String, dynamic> json) => ReceptTags(
      (json['tags'] as List<dynamic>)
          .map((e) => ReceptTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReceptTagsToJson(ReceptTags instance) =>
    <String, dynamic>{
      'tags': instance.tags,
    };

ReceptTag _$ReceptTagFromJson(Map<String, dynamic> json) => ReceptTag(
      json['tag'] as String?,
    );

Map<String, dynamic> _$ReceptTagToJson(ReceptTag instance) => <String, dynamic>{
      'tag': instance.tag,
    };
