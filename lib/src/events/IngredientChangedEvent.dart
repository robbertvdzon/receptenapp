import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/ingredients/v1/ingredients.dart';

class IngredientChangedEvent {
  Ingredient ingredient;

  IngredientChangedEvent(this.ingredient);
}
