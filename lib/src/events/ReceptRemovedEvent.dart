import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/recipes/v1/recept.dart';

class ReceptRemovedEvent {
  Recept recept;

  ReceptRemovedEvent(this.recept);
}
