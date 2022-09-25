import 'package:event_bus/event_bus.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';

import '../GetItDependencies.dart';
import '../events/IngredientChangedEvent.dart';
import '../model/ingredients/v1/ingredients.dart';

class IngredientsService {
  var _eventBus = getIt<EventBus>();
  var _ingredientsRepository = getIt<IngredientsRepository>();

  Future<void> saveIngredient(Ingredient ingredient) async {
    return _ingredientsRepository.saveIngredient(ingredient).then((value) => {
      _eventBus.fire(IngredientChangedEvent(ingredient))
    });
  }

  Future<Ingredient> createAndAddIngredient(String name) {
    return _ingredientsRepository.createAndAddIngredient(name);
  }


}
