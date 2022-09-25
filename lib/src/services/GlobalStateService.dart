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

class GlobalStateService {
  StreamSubscription? _eventStreamSub;
  var _state = _GlobalState();
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

  List<Recept> recipes() => _state.recipes;
  List<Ingredient> ingredients() => _state.ingredients;
  List<IngredientTag> ingredientTags() => _state.ingredientTags;
  List<Product> products() => _state.products;
  List<ReceptTag> receptTags() => _state.receptTags;
  User? user() => _state.user;

  // filter data
  List<Recept> filteredRecipes = List.empty();


  @override
  void dispose() {
    _eventStreamSub?.cancel();
  }

  void _loadFromStore(){
    _state.recipes = _recipesRepository.cachedRecipes?.recipes??List.empty();
    _state.ingredients = _ingredientsRepository.cachedIngredients?.ingredients??List.empty();
    _state.ingredientTags = _ingredientTagsRepository.cachedTags?.tags??List.empty();
    _state.products = _productsRepository.cachedProducts?.products??List.empty();
    _state.receptTags = _recipesTagsRepository.cachedTags?.tags??List.empty();
    _state.user = _userRepository.getUser();
  }

}


class _GlobalState {
  // stamdata
  List<Recept> recipes = List.empty();
  List<Ingredient> ingredients = List.empty();
  List<IngredientTag> ingredientTags = List.empty();
  List<Product> products = List.empty();
  List<ReceptTag> receptTags = List.empty();
  User? user = null;

  // filter data
  // List<Recept> filteredRecipes = List.empty();

}