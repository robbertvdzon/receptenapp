import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:receptenapp/src/services/IngredientsRepository.dart';

import '../global.dart';
import '../model/model.dart';

class IngredientTagsRepository {
  final String _DOCNAME = "ingredienttags";
  final String _KEY = "data";
  String? usersCollection = null;

  IngredientTags? cachedTags = null;

  var _db = getIt<FirebaseFirestore>();
  var _ingredientsRepository = getIt<IngredientsRepository>();

  Future<IngredientTags> init(String email) {
    usersCollection = email;
    return _loadTags();
  }

  IngredientTags getTags() {
    if (cachedTags == null) throw Exception("Repository not initialized");
    Set<String> listTagStringsFromIngredients = _ingredientsRepository.getIngredients().ingredients.expand((e) => e.tags).toSet();
    Set<String> listTagStringsFromDatabase = cachedTags!.tags.map((e) => e.tag!).toSet();
    Set<String> allTagStrings = listTagStringsFromDatabase..addAll(listTagStringsFromIngredients);
    List<IngredientTag> allTags = allTagStrings.map((e) => new IngredientTag(e)).toList();
    return IngredientTags(allTags);
  }

  IngredientTag? getTagByTag (String tag) {
    return getTags().tags.firstWhereOrNull((element) => element.tag==tag);
  }

  Future<void> saveTag(IngredientTag tag) async {
    var tags = getTags();
    var oldTag = tags.tags.firstWhereOrNull((element) => element.tag==tag.tag);
    if (oldTag!=null){
      tags.tags.remove(oldTag);
    }
    tags.tags.add(tag);
    return saveTags(tags);
  }

  Future<void> saveTags(IngredientTags tags) async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final Map<String, dynamic> jsonMap = tags.toJson();
    final jsonKeyValue = <String, String>{_KEY: jsonEncode(jsonMap)};
    return _db
        .collection(usersCollection!)
        .doc(_DOCNAME)
        .set(jsonKeyValue)
        .onError((e, _) => print("Error writing document: $e"))
        .then((data) => cachedTags = tags);
  }

  Future<IngredientTag> createAndAddTag(String name) async {
    return _loadTags().then((tags) {
      final tag = IngredientTag(name);
      tags.tags.add(tag);
      return saveTags(tags).then((value) => tag);
    });
  }

  void setSampleTags() {
    saveTags(_createSample());
  }

  IngredientTags _createSample() {
    var cat1 = IngredientTag("cat1");
    var cat2 = IngredientTag("cat2");
    return IngredientTags([cat1, cat2]);
  }


  Future<IngredientTags> _loadTags() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final tags = IngredientTags.fromJson(jsonObj);
      cachedTags = tags;
      return tags;
    }
    return IngredientTags(List.empty());
  }

}
