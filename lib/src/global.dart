import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:receptenapp/src/services/enricher/Enricher.dart';
import 'package:receptenapp/src/services/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/services/repositories/IngredientsRepository.dart';
import 'package:receptenapp/src/services/repositories/ProductsRepository.dart';
import 'package:receptenapp/src/services/repositories/RecipesRepository.dart';
import 'package:receptenapp/src/services/repositories/RecipesTagsRepository.dart';
import 'package:receptenapp/src/services/repositories/Repositories.dart';
import 'package:receptenapp/src/services/repositories/UserRepository.dart';
import 'package:receptenapp/src/ui/state/UIRecepenGlobalState.dart';

import '../firebase_options.dart';

final bool PRELOAD_DATABASE_AT_STARTUP = false;
final bool DISABLE_AUTH = true;

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<UserRepository>(UserRepository());
  getIt.registerSingleton<RecipesRepository>(RecipesRepository());
  getIt.registerSingleton<IngredientsRepository>(IngredientsRepository());
  getIt.registerSingleton<ProductsRepository>(ProductsRepository());
  getIt.registerSingleton<IngredientTagsRepository>(IngredientTagsRepository());
  getIt.registerSingleton<RecipesTagsRepository>(RecipesTagsRepository());
  getIt.registerSingleton<Repositories>(Repositories());
  getIt.registerSingleton<Enricher>(Enricher());
  getIt.registerSingleton<EventBus>(EventBus());
  getIt.registerSingleton<UIReceptenGlobalState>(UIReceptenGlobalState());
}
