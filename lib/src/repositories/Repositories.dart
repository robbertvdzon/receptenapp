import 'package:event_bus/event_bus.dart';
import 'package:receptenapp/src/repositories/IngredientTagsRepository.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import 'package:receptenapp/src/repositories/ProductsRepository.dart';
import 'package:receptenapp/src/repositories/RecipesRepository.dart';

import '../GetItDependencies.dart';
import '../Toggles.dart';
import '../events/RepositoriesLoadedEvent.dart';
import 'DiaryRepository.dart';
import 'RecipesTagsRepository.dart';
import 'SnacksRepository.dart';
import 'UserRepository.dart';


class Repositories {
  var _ingredientsRepository = getIt<IngredientsRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _recipesRepository = getIt<RecipesRepository>();
  var _snacksRepository = getIt<SnacksRepository>();
  var _ingredientTagsRepository = getIt<IngredientTagsRepository>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _userRepository = getIt<UserRepository>();
  var _diaryRepository = getIt<DiaryRepository>();
  var _eventBus = getIt<EventBus>();

  void initRepositories() {
    var email = _userRepository.getUsersEmail();
    List<Future<void>> futures = [
      _productsRepository.init(email),
      _recipesRepository.init(email),
      _snacksRepository.init(email),
      _ingredientTagsRepository.init(email),
      _recipesTagsRepository.init(email),
      _ingredientsRepository.init(email),
      _diaryRepository.init(email)
    ];
    Future.wait(futures).then((value) {
      _eventBus.fire(RepositoriesLoadedEvent());
      if (PRELOAD_DATABASE_AT_STARTUP) {
        _recipesRepository.setSampleRecipes();
        _productsRepository.setSampleProducts();
        _ingredientTagsRepository.setSampleTags();
        _recipesTagsRepository.setSampleTags();
        _ingredientsRepository.setSampleIngredients();
      }
      return null;
    });
  }
}
