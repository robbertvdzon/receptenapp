import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../events/RepositoriesLoadedEvent.dart';
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

class AppStateService {
  // stamdata
  List<Recept> recipes = List.empty();
  List<Ingredient> ingredients = List.empty();
  List<IngredientTag> ingredientTags = List.empty();
  List<Product> products = List.empty();
  List<ReceptTag> receptTags = List.empty();
  User? user = null;

  // filter data
  List<Recept> filteredRecipes = List.empty();
  
  StreamSubscription? _eventStreamSub;
  var _eventBus = getIt<EventBus>();
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _userRepository = getIt<UserRepository>();

  void init(){
    _eventStreamSub = _eventBus.on<RepositoriesLoadedEvent>().listen((event) {
      _loadFromStore();
    });
  }

  List<Recept> getRecipes() => recipes;
  List<Ingredient> getIngredients() => ingredients;
  List<IngredientTag> getIngredientTags() => ingredientTags;
  List<Product> getProducts() => products;
  List<ReceptTag> getReceptTags() => receptTags;
  User? getUser() => user;

  List<Recept> getFilteredRecipes() => filteredRecipes;
  setFilteredRecipes(List<Recept> recipes) {
    filteredRecipes = recipes;
  }


  @override
  void dispose() {
    _eventStreamSub?.cancel();
  }

  void _loadFromStore(){
    recipes = _recipesRepository.cachedRecipes?.recipes??List.empty();
    ingredients = _ingredientsRepository.cachedIngredients?.ingredients??List.empty();
    ingredientTags = _ingredientTagsRepository.cachedTags?.tags??List.empty();
    products = _productsRepository.cachedProducts?.products??List.empty();
    receptTags = _recipesTagsRepository.cachedTags?.tags??List.empty();
    user = _userRepository.getUser();
  }


}


