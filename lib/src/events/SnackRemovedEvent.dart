import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import '../model/snacks/v1/snack.dart';

class SnackRemovedEvent {
  Snack snack;

  SnackRemovedEvent(this.snack);
}

