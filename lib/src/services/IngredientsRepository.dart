import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../global.dart';
import '../model/model.dart';
import 'UserRepository.dart';


class IngredientsRepository {

  final String _DOCNAME = "ingredients";
  final String _KEY = "data";

  var _db = getIt<FirebaseFirestore>();
  var _userRepository = getIt<UserRepository>();

  void printIngredients() {
    loadIngredients().then((data) =>
        print(data)
    );
  }

  Future<Ingredients> loadIngredients() async {
    final email = _userRepository.getUsersEmail();
    final event = await _db.collection(email).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final ingredientCategories = Ingredients.fromJson(jsonObj);
      return ingredientCategories;
    }
    return Ingredients(List.empty());
  }

  void saveIngredients(Ingredients ingredients) {
    final email = _userRepository.getUsersEmail();
    final Map<String, dynamic> json = ingredients.toJson();
    final receptenBoekJson = <String, String>{_KEY: jsonEncode(json)};
    _db
        .collection(email)
        .doc(_DOCNAME)
        .set(receptenBoekJson)
        .onError((e, _) => print("Error writing document: $e"));
    print("ingredientCategories saves");

  }

  Future<Ingredients> addIngredient(String name) async {
    return loadIngredients().then((ingredients) => _addIngredient(ingredients, name));
  }

  Future<Ingredients> _addIngredient(Ingredients ingredients, String name) async {
    final ingredient = Ingredient(name);
    ingredients.ingredients.add(ingredient);
    saveIngredients(ingredients);
    return ingredients;
  }


}
