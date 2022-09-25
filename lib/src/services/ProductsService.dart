import 'dart:convert';

import '../model/products/v1/products.dart';
import '../repositories/ProductsRepository.dart';
import '../GetItDependencies.dart';
import 'package:collection/collection.dart';

class ProductsService {
  var _productsRepository = getIt<ProductsRepository>();

  Product? getProductByName (String name) {
    return _productsRepository.getProducts().products.firstWhereOrNull((element) => element.name==name);
  }

}
