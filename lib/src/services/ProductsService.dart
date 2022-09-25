import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';

import '../GetItDependencies.dart';
import '../events/ProductChangedEvent.dart';
import '../events/ProductCreatedEvent.dart';
import '../model/products/v1/products.dart';
import '../repositories/ProductsRepository.dart';

class ProductsService {
  var _productsRepository = getIt<ProductsRepository>();
  var _eventBus = getIt<EventBus>();

  Product? getProductByName (String name) {
    return getProducts().products.firstWhereOrNull((element) => element.name==name);
  }

  Products getProducts() {
    return _productsRepository.getProducts();
  }

  Future<void> saveProduct(Product product) {
    // TODO: Dit gaat dus niet goed bij het renamen van een product! Is er niet een ander ID veld dat ik hiervoor kan gebruiken? Of een eigen UUID aanmaken?
    Product? originalProduct = _productsRepository.getProductByName(product.name??"");
    if (originalProduct==null){
      // add product
      return _productsRepository
          .addProduct(product).then((value) => {
        _eventBus.fire(ProductCreatedEvent(product))
      });
    }
    else{
      // save product
      return _productsRepository
          .saveProduct(product).then((value) => {
        _eventBus.fire(ProductChangedEvent(product))
      });
    }
  }

}
