import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:receptenapp/src/global.dart';
import 'package:receptenapp/src/model/model.dart';
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
  var appRepository = getIt<ReceptenRepository>();
  var baseIngredientsRepository = getIt<NutrientsRepository>();
  var ingredientCategoryRepository = getIt<TagsRepository>();

  var cat1 = Tag("cat1");
  var cat2 = Tag("cat2");
  var ingredientCategories = Tags([cat1, cat2]);
  ingredientCategoryRepository.saveTags(ingredientCategories);

  appRepository.addReceptenbookIfNeeded();
  baseIngredientsRepository.addNutrientsIfNeeded();
}

Future<void> setupDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<ReceptenRepository>(ReceptenRepository());
  getIt.registerSingleton<NutrientsRepository>(NutrientsRepository());
  getIt.registerSingleton<UserRepository>(UserRepository());
  getIt.registerSingleton<TagsRepository>(TagsRepository());
}


