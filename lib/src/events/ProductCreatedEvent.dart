import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/ingredients/v1/ingredients.dart';
import '../model/products/v1/products.dart';

class ProductCreatedEvent {
  Product product;

  ProductCreatedEvent(this.product);
}
