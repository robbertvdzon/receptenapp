import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../model/ingredients/v1/ingredients.dart';
import '../model/recipes/v1/recept.dart';

class IngredientCreatedEvent {
  Ingredient ingredient;

  IngredientCreatedEvent(this.ingredient);
}
