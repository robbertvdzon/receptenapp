import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products.g.dart';

var uuid = Uuid();

@JsonSerializable()
class Products {
  List<Product> products;
  Products(this.products);

  factory Products.fromJson(Map<String, dynamic> json) => _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);

}


@JsonSerializable()
class Product {
  String? name;
  String? category;
  int? nevoCode;
  String? quantity;
  String? kcal;
  String? prot;
  String? nt;
  String? fat;
  String? sugar;
  String? na;
  String? k;
  String? fe;
  String? mg;
  bool? customNutrient = false;

  Product(this.name);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

