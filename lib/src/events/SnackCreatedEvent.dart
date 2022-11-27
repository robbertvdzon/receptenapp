import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/snacks/v1/snack.dart';

class SnackCreatedEvent {
  Snack snack;

  SnackCreatedEvent(this.snack);
}

