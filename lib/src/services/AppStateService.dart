import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/model/snacks/v1/snack.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../events/FilterModifiedEvent.dart';
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
import '../repositories/SnacksRepository.dart';
import '../repositories/UserRepository.dart';
import 'Enricher.dart';
import 'Filter.dart';

class AppStateService {
  // stamdata
  List<Recept> recipes = List.empty(growable: true);
  List<Snack> snacks = List.empty(growable: true);
  List<Ingredient> ingredients = List.empty(growable: true);
  List<IngredientTag> ingredientTags = List.empty(growable: true);
  List<Product> products = List.empty(growable: true);
  List<ReceptTag> receptTags = List.empty(growable: true);
  User? user = null;

  // filter data
  Filter filter = Filter();
  List<Recept> filteredRecipes = List.empty(growable: true);
  List<Snack> filteredSnacks = List.empty(growable: true);

  StreamSubscription? _eventStreamSub;
  var _eventBus = getIt<EventBus>();
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _snacksRepository = getIt<SnacksRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _userRepository = getIt<UserRepository>();
  var _enricher = getIt<Enricher>();

  void init(){
    _eventStreamSub = _eventBus.on<RepositoriesLoadedEvent>().listen((event) {
      _loadFromStore();
    });
  }

  List<Recept> getRecipes() => recipes;
  List<Snack> getSnacks() => snacks;
  List<Ingredient> getIngredients() => ingredients;
  List<IngredientTag> getIngredientTags() => ingredientTags;
  List<Product> getProducts() => products;
  List<ReceptTag> getReceptTags() => receptTags;
  User? getUser() => user;

  List<Recept> getFilteredRecipes() => filteredRecipes;
  List<EnrichedRecept> getEnrichedFilteredRecipes() => filteredRecipes.map((recipe) => _enricher.enrichRecipe(recipe)).toList();
  setFilteredRecipes(List<Recept> recipes) {
    filteredRecipes = recipes;
  }

  List<Snack> getFilteredSnacks() => filteredSnacks;
  List<EnrichedSnack> getEnrichedFilteredSnacks() => filteredSnacks.map((recipe) => _enricher.enrichSnack(recipe)).toList();
  setFilteredSnacks(List<Snack> snacks) {
    filteredSnacks = snacks;
  }

  @override
  void dispose() {
    _eventStreamSub?.cancel();
  }

  void _loadFromStore(){
    snacks = _snacksRepository.cachedSnacks?.snacks??List.empty(growable: true);
    recipes = _recipesRepository.cachedRecipes?.recipes??List.empty(growable: true);
    ingredients = _ingredientsRepository.cachedIngredients?.ingredients??List.empty(growable: true);
    ingredientTags = _ingredientTagsRepository.cachedTags?.tags??List.empty(growable: true);
    products = _productsRepository.cachedProducts?.products??List.empty(growable: true);
    receptTags = _recipesTagsRepository.cachedTags?.tags??List.empty(growable: true);
    user = _userRepository.getUser();
  }

  void clearFilter() {
    filter = Filter();
    _eventBus.fire(FilterModifiedEvent());
  }



}


