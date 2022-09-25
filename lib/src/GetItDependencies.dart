import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:receptenapp/src/services/Enricher.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import 'package:receptenapp/src/repositories/ProductsRepository.dart';
import 'package:receptenapp/src/repositories/RecipesRepository.dart';
import 'package:receptenapp/src/repositories/RecipesTagsRepository.dart';
import 'package:receptenapp/src/repositories/Repositories.dart';
import 'package:receptenapp/src/repositories/UserRepository.dart';
import 'package:receptenapp/src/services/GlobalStateService.dart';
import 'package:receptenapp/src/services/IngredientService.dart';
import 'package:receptenapp/src/services/ProductsService.dart';
import 'package:receptenapp/src/services/ReceptService.dart';
import '../firebase_options.dart';
import 'GlobalState.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<EventBus>(EventBus());
  getIt.registerSingleton<GlobalState>(GlobalState());
  getIt.registerSingleton<UserRepository>(UserRepository());
  getIt.registerSingleton<RecipesRepository>(RecipesRepository());
  getIt.registerSingleton<IngredientsRepository>(IngredientsRepository());
  getIt.registerSingleton<ProductsRepository>(ProductsRepository());
  getIt.registerSingleton<IngredientTagsRepository>(IngredientTagsRepository());
  getIt.registerSingleton<RecipesTagsRepository>(RecipesTagsRepository());
  getIt.registerSingleton<Repositories>(Repositories());
  getIt.registerSingleton<ReceptService>(ReceptService());
  getIt.registerSingleton<IngredientService>(IngredientService());
  getIt.registerSingleton<ProductsService>(ProductsService());
  getIt.registerSingleton<GlobalStateService>(GlobalStateService());
  getIt.registerSingleton<Enricher>(Enricher());
}
