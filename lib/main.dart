import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:receptenapp/src/global.dart';
import 'package:receptenapp/src/model/model.dart';
import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/TagsRepository.dart';
import 'package:receptenapp/src/services/NutrientsRepository.dart';
import 'package:receptenapp/src/services/ReceptenRepository.dart';
import 'package:receptenapp/src/services/UserRepository.dart';
import 'package:receptenapp/src/widgets/ReceptenApp.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  addSampleWhenNeeded();

  runApp(ReceptenApp());
}

Future<void> addSampleWhenNeeded() async {
  var recipesRepository = getIt<RecipesRepository>();
  var productsRepository = getIt<ProductsRepository>();
  var ingredientsRepository = getIt<IngredientsRepository>();
  var tagsRepository = getIt<TagsRepository>();

  var cat1 = Tag("cat1");
  var cat2 = Tag("cat2");
  var tags = Tags([cat1, cat2]);
  tagsRepository.saveTags(tags);

  final patat = Ingredient("patat");
  final hamburger = Ingredient("hamburger");
  final brood = Ingredient("brood");
  final boter = Ingredient("boter");
  final kaas = Ingredient("kaas");
  final ingredients = Ingredients([patat, hamburger, brood]);
  ingredientsRepository.saveIngredients(ingredients);


  recipesRepository.addReceptenbookIfNeeded();
  productsRepository.addProductsIfNeeded();
}

Future<void> setupDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<UserRepository>(UserRepository());
  getIt.registerSingleton<IngredientsRepository>(IngredientsRepository());
  getIt.registerSingleton<RecipesRepository>(RecipesRepository());
  getIt.registerSingleton<ProductsRepository>(ProductsRepository());
  getIt.registerSingleton<TagsRepository>(TagsRepository());
}


