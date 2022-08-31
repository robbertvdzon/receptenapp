import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/ProductsRepository.dart';

import '../global.dart';
import '../model/enrichedmodels.dart';
import '../model/model.dart';
import 'UserRepository.dart';

class Enricher {

  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();

  EnrichedRecept? enrichRecipe(Recept recept) {
    // _ingredientsRepository.loadIngredients().then((value) => test(value));

    return null;
  }

  test(Ingredients value) {}


}

