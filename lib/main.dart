import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:receptenapp/src/global.dart';
import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/RecipesTagsRepository.dart';
import 'package:receptenapp/src/services/Repositories.dart';
import 'package:receptenapp/src/services/IngredientTagsRepository.dart';
import 'package:receptenapp/src/services/ProductsRepository.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';
import 'package:receptenapp/src/services/UserRepository.dart';
import 'package:receptenapp/src/widgets/ReceptenApp.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  print("STARTING");
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(ReceptenApp());
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
  getIt.registerSingleton<IngredientTagsRepository>(IngredientTagsRepository());
  getIt.registerSingleton<RecipesTagsRepository>(RecipesTagsRepository());
  getIt.registerSingleton<Repositories>(Repositories());
}


