import 'package:event_bus/event_bus.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';

import '../GetItDependencies.dart';
import '../events/IngredientChangedEvent.dart';
import '../events/IngredientCreatedEvent.dart';
import '../model/ingredients/v1/ingredients.dart';

class IngredientsService {
  var _eventBus = getIt<EventBus>();
  var _ingredientsRepository = getIt<IngredientsRepository>();

  Future<void> saveIngredient(Ingredient ingredient) {
    Ingredient? originalIngredient = _ingredientsRepository.getIngredientByUuid(ingredient.uuid);
    if (originalIngredient==null){
      // add recept
      return _ingredientsRepository
          .addIngredient(ingredient).then((value) => {
        _eventBus.fire(IngredientCreatedEvent(ingredient))
      });
    }
    else{
      // save recept
      return _ingredientsRepository
          .saveIngredient(ingredient).then((value) => {
        _eventBus.fire(IngredientChangedEvent(ingredient))
      });
    }
  }

}
