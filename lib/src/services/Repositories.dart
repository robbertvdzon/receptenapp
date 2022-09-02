import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/ProductsRepository.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';
import 'package:receptenapp/src/services/IngredientTagsRepository.dart';

import '../global.dart';
import 'RecipesTagsRepository.dart';
import 'UserRepository.dart';

class Repositories {
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _userRepository = getIt<UserRepository>();

  void initRepositories() {
    var email = _userRepository.getUsersEmail();
    List<Future<void>> futures = [
      _productsRepository.init(email),
      _recipesRepository.init(email),
      _ingredientTagsRepository.init(email),
      _recipesTagsRepository.init(email),
      _ingredientsRepository.init(email)
    ];
    Future.wait(futures).then((value) {
      _recipesRepository.setSampleRecipes();
      _productsRepository.setSampleProducts();
      _ingredientTagsRepository.setSampleTags();
      _recipesTagsRepository.setSampleTags();
      _ingredientsRepository.setSampleIngredients();
      return null;
    });
  }
}
