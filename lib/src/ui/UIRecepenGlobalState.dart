import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../global.dart';
import '../model/ingredients/v1/ingredientTags.dart';
import '../model/ingredients/v1/ingredients.dart';
import '../model/products/v1/products.dart';
import '../model/recipes/v1/recept.dart';
import '../model/recipes/v1/receptTags.dart';
import '../repositories/IngredientTagsRepository.dart';
import '../repositories/IngredientsRepository.dart';
import '../repositories/ProductsRepository.dart';
import '../repositories/RecipesRepository.dart';
import '../repositories/RecipesTagsRepository.dart';
import '../repositories/UserRepository.dart';

class UIReceptenGlobalState {
  // stamdata
  List<Recept> recipes = List.empty();
  List<Ingredient> ingredients = List.empty();
  List<IngredientTag> ingredientTags = List.empty();
  List<Product> products = List.empty();
  List<ReceptTag> receptTags = List.empty();
  User? user = null;

  // filter data
  List<Recept> filteredRecipes = List.empty();
  
  // eventbus
  var eventBus = getIt<EventBus>();
 
  // repositores
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _userRepository = getIt<UserRepository>();

  // TODO: moeten onderstaade functies niet naar een service?
  void loadFromStore(){
    recipes = _recipesRepository.cachedRecipes?.recipes??List.empty();
    ingredients = _ingredientsRepository.cachedIngredients?.ingredients??List.empty();
    ingredientTags = _ingredientTagsRepository.cachedTags?.tags??List.empty();
    products = _productsRepository.cachedProducts?.products??List.empty();
    receptTags = _recipesTagsRepository.cachedTags?.tags??List.empty();
    user = _userRepository.getUser();
  }

}
