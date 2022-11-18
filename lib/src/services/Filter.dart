import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../events/RepositoriesLoadedEvent.dart';
import '../model/enriched/enrichedmodels.dart';
import '../model/ingredients/v1/ingredientTags.dart';
import '../model/ingredients/v1/ingredients.dart';
import '../model/products/v1/products.dart';
import '../model/recipes/v1/recept.dart';
import '../model/recipes/v1/receptTags.dart';
import '../repositories/ProductsRepository.dart';
import '../GetItDependencies.dart';
import '../repositories/RecipesRepository.dart';
import '../repositories/RecipesTagsRepository.dart';
import '../repositories/UserRepository.dart';
import 'Enricher.dart';

class Filter {
  String nameFilter = "";
  String ingredientsFilter = "";
  String tagFilter = "";
  String maxCoockTime = "";
  bool favorite = false;
}


