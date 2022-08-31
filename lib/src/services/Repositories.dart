import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/ProductsRepository.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';
import 'package:receptenapp/src/services/IngredientTagsRepository.dart';

import '../global.dart';
import '../model/model.dart';
import 'UserRepository.dart';

class Repositories {
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _tagsRepository = getIt<IngredientTagsRepository>();
  var _userRepository = getIt<UserRepository>();


  void initRepositories() {
    var email = _userRepository.getUsersEmail();
    List<Future<void>> futures = [
       _productsRepository.init(email),
      _recipesRepository.init(email),
      _tagsRepository.init(email),
      _ingredientsRepository.init(email)
    ];
    Future.wait(futures).then((value) {
       _recipesRepository.setSampleRecipes();
       _productsRepository.setSampleProducts();
       _tagsRepository.setSampleTags();
       _ingredientsRepository.setSampleIngredients();
       return null;
    });
  }

}
