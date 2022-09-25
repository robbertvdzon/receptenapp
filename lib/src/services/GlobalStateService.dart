import 'dart:async';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../events/RepositoriesLoadedEvent.dart';
import '../repositories/ProductsRepository.dart';
import '../GetItDependencies.dart';
import '../repositories/RecipesRepository.dart';
import '../repositories/RecipesTagsRepository.dart';
import '../GlobalState.dart';
import '../repositories/UserRepository.dart';

class GlobalStateService {
  StreamSubscription? _eventStreamSub;

  var _state = getIt<GlobalState>();
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _userRepository = getIt<UserRepository>();

  void init(){
    _eventStreamSub = _state.eventBus.on<RepositoriesLoadedEvent>().listen((event) {
      _loadFromStore();
    });
  }

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
    print(_state.products);
  }

}
