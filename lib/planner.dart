import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:receptenapp/src/global.dart';
import 'package:receptenapp/src/services/repositories/IngredientsRepository.dart';
import 'package:receptenapp/src/services/repositories/RecipesTagsRepository.dart';
import 'package:receptenapp/src/services/repositories/Repositories.dart';
import 'package:receptenapp/src/services/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/services/repositories/ProductsRepository.dart';
import 'package:receptenapp/src/services/repositories/RecipesRepository.dart';
import 'package:receptenapp/src/services/repositories/UserRepository.dart';
import 'package:receptenapp/src/ui/ReceptenApp.dart';
import 'package:receptenapp/src/ui/planner/PlannerApp.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  print("STARTING PLANNER");
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(PlannerApp());
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


