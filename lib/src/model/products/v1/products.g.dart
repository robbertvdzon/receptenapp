// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
      ..quantity = (json['quantity'] as num?)?.toDouble()
      ..kcal = (json['kcal'] as num?)?.toDouble()
      ..prot = (json['prot'] as num?)?.toDouble()
      ..nt = (json['nt'] as num?)?.toDouble()
      ..fat = (json['fat'] as num?)?.toDouble()
      ..sugar = (json['sugar'] as num?)?.toDouble()
      ..na = (json['na'] as num?)?.toDouble()
      ..k = (json['k'] as num?)?.toDouble()
      ..fe = (json['fe'] as num?)?.toDouble()
      ..mg = (json['mg'] as num?)?.toDouble()
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
