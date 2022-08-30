import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../global.dart';
import '../model/model.dart';
import 'UserRepository.dart';

class RecipesRepository {

  final String _DOCNAME = "recipes";
  final String _KEY = "data";

  var _db = getIt<FirebaseFirestore>();
  var _userRepository = getIt<UserRepository>();

  void addReceptenbookIfNeeded() {
    final email = _userRepository.getUsersEmail();
    _db.collection(email).doc(_DOCNAME).get().then((event) {
      var data = event.data();
      if (data == null) {
        final sample = createSample();
        final Map<String, dynamic> json = sample.toJson();
        final receptenboeken = <String, String>{_KEY: jsonEncode(json)};
        _db
            .collection(email)
            .doc(_DOCNAME)
            .set(receptenboeken)
            .onError((e, _) => print("Error writing document: $e"));
        print("sample book interted");
      }
    });
  }

  void printTags() {
    loadRecipes().then((data) =>
        print(data)
    );
  }

  Future<Recipes> loadRecipes() async {
    final email = _userRepository.getUsersEmail();
    final event = await _db.collection(email).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final ingredientCategories = Recipes.fromJson(jsonObj);
      return ingredientCategories;
    }
    return Recipes(List.empty());
  }

  void saveTags(Recipes recipes) {
    final email = _userRepository.getUsersEmail();
    final Map<String, dynamic> json = recipes.toJson();
    final receptenBoekJson = <String, String>{_KEY: jsonEncode(json)};
    _db
        .collection(email)
        .doc(_DOCNAME)
        .set(receptenBoekJson)
        .onError((e, _) => print("Error writing document: $e"));
    print("ingredientCategories saves");

  }


  Recipes createSample() {
    final patat = Ingredient("patat");
    final hamburger = Ingredient("hamburger");
    final brood = Ingredient("brood");
    final boter = Ingredient("boter");
    final kaas = Ingredient("kaas");
    final hamburgermenu = Recept([patat, hamburger, brood], "hamburgermenu");
    final broodjeKaas = Recept([brood, boter, kaas], "broodje kaas");
    final receptenboek = Recipes(
      [hamburgermenu, broodjeKaas],
    );
    return receptenboek;
  }

}

