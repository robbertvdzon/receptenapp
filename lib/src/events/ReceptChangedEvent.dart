import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

class ReceptChangedEvent {
  String? uuid;

  ReceptChangedEvent(this.uuid);
}
