import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '../global.dart';
import '../model/model.dart';



class RecipesRepository {
  final String _DOCNAME = "recipes";
  final String _KEY = "data";
  String? usersCollection = null;

  Recipes? cachedRecipes = null;

  var _db = getIt<FirebaseFirestore>();

  Future<Recipes> init(String email) {
    usersCollection = email;
    return _loadRecipes();
  }

  Recipes getRecipes() {
    if (cachedRecipes == null) throw Exception("Repository not initialized");
    return cachedRecipes!;
  }

  Recept? getReceptByName (String name) {
    return getRecipes().recipes.firstWhereOrNull((element) => element.name==name);
  }

  Recept? getReceptByUuid (String uuid) {
    return getRecipes().recipes.firstWhereOrNull((element) => element.uuid==uuid);
  }

  Future<void> saveRecept(Recept recept) async {
    var recipes = getRecipes();
    var oldRecept = recipes.recipes.firstWhereOrNull((element) => element.uuid==recept.uuid);
    if (oldRecept!=null){
      recipes.recipes.remove(oldRecept);
    }
    recipes.recipes.add(recept);
    return saveRecipes(recipes);
  }

  Future<void> saveRecipes(Recipes recipes) async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final Map<String, dynamic> jsonMap = recipes.toJson();
    final jsonKeyValue = <String, String>{_KEY: jsonEncode(jsonMap)};
    return _db
        .collection(usersCollection!)
        .doc(_DOCNAME)
        .set(jsonKeyValue)
        .onError((e, _) => print("Error writing document: $e"))
        .then((data) => cachedRecipes = recipes);
  }

  Future<Recept> createAndAddRecept(String name) async {
    return _loadRecipes().then((recipes) {
      final recept = Recept(List.empty(),name);
      recipes.recipes.add(recept);
      return saveRecipes(recipes).then((value) => recept);
    });
  }

  Future<Recipes> _loadRecipes() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final recipes = Recipes.fromJson(jsonObj);
      cachedRecipes = recipes;
      return recipes;
    }
    return Recipes(List.empty());
  }

  void setSampleRecipes() {
    saveRecipes(_createSample());
  }
  
  Recipes _createSample() {
    final patat = Ingredient("patat");
    final hamburger = Ingredient("hamburger");
    final brood = Ingredient("brood");
    final boter = Ingredient("boter");
    final kaas = Ingredient("kaas");
    final hamburgermenu = Recept([patat, hamburger, brood], "hamburger");
    hamburgermenu.tags = ["zuivel","vlees"];
    final broodjeKaas = Recept([brood, boter, kaas], "kaas broodje");
    broodjeKaas.tags = ["zuivel","vegatarisch"];

    final noedelsoep = Recept([
      Ingredient("gember"),
      Ingredient("knoflook"),
      Ingredient("eiernoedels"),
      Ingredient("zonnebloemolie"),
      Ingredient("water"),
      Ingredient("groentebouillontabletten"),
      Ingredient("sojasaus"),
      Ingredient("rijstazijn"),
      Ingredient("shitakes"),
      Ingredient("paksoi"),
      Ingredient("sesamzaad"),
    ], "Noedelsoep met shiitake en paksoi");
    noedelsoep.directions = "Snijd de gember in dunne plakjes.\nSnijd de knoflook.\nKook de noedels..................";
    noedelsoep.tags = ["vlees","soep"];
    final receptenboek = Recipes(
      [hamburgermenu, broodjeKaas, noedelsoep],
    );
    return receptenboek;
  }  
  
}



