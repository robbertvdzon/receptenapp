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
import 'package:receptenapp/src/services/RecipesService.dart';
import '../firebase_options.dart';
import 'GlobalState.dart';

final bool PRELOAD_DATABASE_AT_STARTUP = false;
final bool DISABLE_AUTH = true;
