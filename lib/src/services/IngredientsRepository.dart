import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '../global.dart';
import '../model/ingredients/v1/ingredients.dart';

class IngredientsRepository {
  final String _DOCNAME = "ingredients";
  final String _KEY = "data";
  String? usersCollection = null;

  Ingredients? cachedIngredients = null;

  var _db = getIt<FirebaseFirestore>();

  Future<Ingredients> init(String email) {
    usersCollection = email;
    return _loadIngredients();
  }

  Ingredients getIngredients() {
    if (cachedIngredients == null) throw Exception("Repository not initialized");
    return cachedIngredients!;
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
    return saveIngredients(ingredients);
  }

  Future<void> saveIngredients(Ingredients ingredients) async {
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

  Future<Ingredient> createAndAddIngredient(String name) async {
    return _loadIngredients().then((ingredients) {
      final ingredient = Ingredient(name);
      ingredients.ingredients.add(ingredient);
      return saveIngredients(ingredients).then((value) => ingredient);
    });
  }

  void setSampleIngredients() {
    saveIngredients(_createSample());
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
    sojasaus.nutrientName = "Ketjap zout";
    sojasaus.tags = ["houdbaar","potje"];
    final gember = Ingredient("gember");
    gember.nutrientName = "Gemberwortel";
    gember.tags = ["houdbaar", "biologisch"];
    return Ingredients([patat, hamburger, brood, sojasaus, gember]);
  }
}
