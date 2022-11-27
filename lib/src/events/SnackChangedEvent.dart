import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/snacks/v1/snack.dart';


class SnackChangedEvent {
  Snack snack;

  SnackChangedEvent(this.snack);
}
