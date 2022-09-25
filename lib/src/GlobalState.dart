import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'GetItDependencies.dart';
import 'model/ingredients/v1/ingredientTags.dart';
import 'model/ingredients/v1/ingredients.dart';
import 'model/products/v1/products.dart';
import 'model/recipes/v1/recept.dart';
import 'model/recipes/v1/receptTags.dart';

class GlobalState {
  // stamdata
  List<Recept> recipes = List.empty();
  List<Ingredient> ingredients = List.empty();
  List<IngredientTag> ingredientTags = List.empty();
  List<Product> products = List.empty();
  List<ReceptTag> receptTags = List.empty();
  User? user = null;

  // filter data
  List<Recept> filteredRecipes = List.empty();

}
