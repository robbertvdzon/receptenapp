import 'package:event_bus/event_bus.dart';

import '../GetItDependencies.dart';
import '../events/ReceptChangedEvent.dart';
import '../events/ReceptCreatedEvent.dart';
import '../events/ReceptRemovedEvent.dart';
import '../model/recipes/v1/recept.dart';
import '../repositories/RecipesRepository.dart';

class RecipesService {
  var _recipesRepository = getIt<RecipesRepository>();
  var _eventBus = getIt<EventBus>();

  Future<void> saveRecept(Recept recept)  {
    Recept? originalRecept = _recipesRepository.getReceptByUuid(recept.uuid);
    if (originalRecept==null){
      // add recept
      return _recipesRepository
          .addRecept(recept)
          .whenComplete(() => _eventBus.fire(ReceptCreatedEvent(recept)));
    }
    else{
      // save recept
      return _recipesRepository
          .saveRecept(recept)
          .whenComplete(() => _eventBus.fire(ReceptChangedEvent(recept)));
    }
  }

  Future<void> removeRecept(Recept recept) async {
    _recipesRepository.removeRecept(recept.uuid).whenComplete(() =>
        _eventBus.fire(ReceptRemovedEvent(recept))
    );
  }


}
