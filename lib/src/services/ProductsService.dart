import 'dart:convert';

import '../model/products/v1/products.dart';
import '../repositories/ProductsRepository.dart';
import '../GetItDependencies.dart';
import 'package:collection/collection.dart';

class ProductsService {
  var _productsRepository = getIt<ProductsRepository>();

  Product? getProductByName (String name) {
    return getProducts().products.firstWhereOrNull((element) => element.name==name);
  }

  Products getProducts() {
    return _productsRepository.getProducts();
  }

  Future<void> saveProduct(Product product) {
    return _productsRepository.saveProduct(product);
  }


  Future<void> saveProducts(Products products) {
    return _productsRepository.saveProducts(products);
  }

  Future<Product> createAndAddProduct(String name) {
    return _productsRepository.createAndAddProduct(name);
  }

}
