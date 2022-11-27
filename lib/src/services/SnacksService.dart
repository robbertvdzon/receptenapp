import 'package:event_bus/event_bus.dart';

import '../GetItDependencies.dart';
import '../events/SnackChangedEvent.dart';
import '../events/SnackCreatedEvent.dart';
import '../events/SnackRemovedEvent.dart';
import '../model/snacks/v1/snack.dart';
import '../repositories/SnacksRepository.dart';

class SnacksService {
  var _snacksRepository = getIt<SnacksRepository>();
  var _eventBus = getIt<EventBus>();

  Future<void> saveSnack(Snack snack)  {
    Snack? originalSnack = _snacksRepository.getSnackByUuid(snack.uuid);
    if (originalSnack==null){
      // add snack
      return _snacksRepository
          .addSnack(snack)
          .whenComplete(() => _eventBus.fire(SnackCreatedEvent(snack)));
    }
    else{
      // save snack
      return _snacksRepository
          .saveSnack(snack)
          .whenComplete(() => _eventBus.fire(SnackChangedEvent(snack)));
    }
  }

  Future<void> removeSnack(Snack snack) async {
    _snacksRepository.removeSnack(snack.uuid).whenComplete(() =>
        _eventBus.fire(SnackRemovedEvent(snack))
    );
  }


}
