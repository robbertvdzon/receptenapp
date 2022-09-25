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
  double? quantity;
  double? kcal;
  double? prot;
  double? nt;
  double? fat;
  double? sugar;
  double? na;
  double? k;
  double? fe;
  double? mg;
  bool? customProduct = false;

  Product(this.name);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

