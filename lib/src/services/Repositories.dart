import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/NutrientsRepository.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';
import 'package:receptenapp/src/services/TagsRepository.dart';

import '../global.dart';
import '../model/model.dart';
import 'UserRepository.dart';

class Repositories {
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _tagsRepository = getIt<TagsRepository>();
  var _userRepository = getIt<UserRepository>();

  void initRepositories2() async {
    var email = _userRepository.getUsersEmail();
    List<Future<void>> futures = [
      // _productsRepository.init(email),
      // _recipesRepository.init(email),
      // _tagsRepository.init(email),
      _ingredientsRepository.init(email)
    ];
    await Future.wait(futures);
  }

  void initRepositories() {
    var email = _userRepository.getUsersEmail();
    List<Future<void>> futures = [
      // _productsRepository.init(email),
      // _recipesRepository.init(email),
      // _tagsRepository.init(email),
      _ingredientsRepository.init(email)
    ];
    Future.wait(futures);
  }


}
