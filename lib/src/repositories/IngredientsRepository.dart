import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import '../GetItDependencies.dart';
import '../model/ingredients/v1/ingredients.dart';
import 'RecipesRepository.dart';


class IngredientsRepository {
  String? usersCollection = null;
  Ingredients? cachedIngredients = null;

  final _DOCNAME = "ingredients";
  final _KEY = "v1";
  var _db = getIt<FirebaseFirestore>();
  var _recipesRepository = getIt<RecipesRepository>();

  Future<Ingredients> init(String email) {
    usersCollection = email;
    return _loadIngredients();
  }

  Ingredients getIngredients() {
    if (cachedIngredients == null) throw Exception("Repository not initialized");
    Set<String> allIngredientsFromRecepts = _recipesRepository.getRecipes().recipes.expand((e) => e.ingredients).map((e) => e.name).toSet();
    var combinedIngredients = cachedIngredients!.ingredients;
    allIngredientsFromRecepts.forEach((ingredient) {
      if (combinedIngredients.where((element) => element.name==ingredient).isEmpty){
        combinedIngredients.add(Ingredient(ingredient));
      }
    });
    return Ingredients(combinedIngredients);
  }

  Ingredient? getIngredientByName (String name) {
    return getIngredients().ingredients.firstWhereOrNull((element) => element.name==name);
  }

  Ingredient? getIngredientByUuid (String uuid) {
    return getIngredients().ingredients.firstWhereOrNull((element) => element.uuid==uuid);
  }

  Future<void> saveIngredient(Ingredient ingredient) async {
    var ingredients = getIngredients();
    var oldIngredient = ingredients.ingredients.firstWhereOrNull((element) => element.uuid==ingredient.uuid);
    if (oldIngredient!=null){
      ingredients.ingredients.remove(oldIngredient);
    }
    ingredients.ingredients.add(ingredient);
    return _saveIngredients(ingredients);
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    var ingredients = getIngredients();
    ingredients.ingredients.add(ingredient);
    return _saveIngredients(ingredients);
  }

  Future<void> _saveIngredients(Ingredients ingredients) async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final Map<String, dynamic> jsonMap = ingredients.toJson();
    final jsonKeyValue = <String, String>{_KEY: jsonEncode(jsonMap)};
    return _db
        .collection(usersCollection!)
        .doc(_DOCNAME)
        .set(jsonKeyValue)
        .onError((e, _) => print("Error writing document: $e"))
        .then((data) => cachedIngredients = ingredients);
  }

  void setSampleIngredients() {
    _saveIngredients(_createSample());
  }

  Future<Ingredients> _loadIngredients() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final ingredients = Ingredients.fromJson(jsonObj);
      cachedIngredients = ingredients;
      return ingredients;
    }
    return Ingredients(List.empty());
  }

  Ingredients _createSample(){
    final patat = Ingredient("patat");
    final hamburger = Ingredient("hamburger");
    final brood = Ingredient("brood");
    final sojasaus = Ingredient("sojasaus");
    sojasaus.productName = "Ketjap zout";
    sojasaus.tags = ["houdbaar","potje"];
    final gember = Ingredient("gember");
    gember.productName = "Gemberwortel";
    gember.tags = ["houdbaar", "biologisch"];
    gember.gramsPerPiece = 25;
    return Ingredients([patat, hamburger, brood, sojasaus, gember]);
  }
}
