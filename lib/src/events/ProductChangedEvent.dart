import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/ingredients/v1/ingredients.dart';
import '../model/products/v1/products.dart';

class ProductChangedEvent {
  Product product;

  ProductChangedEvent(this.product);
}
