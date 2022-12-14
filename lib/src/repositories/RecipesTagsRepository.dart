import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:receptenapp/src/repositories/RecipesRepository.dart';

import '../GetItDependencies.dart';
import '../model/recipes/v1/receptTags.dart';

class RecipesTagsRepository {
  String? usersCollection = null;
  ReceptTags? cachedTags = null;

  final _DOCNAME = "recipestags";
  final _KEY = "v1";
  var _db = getIt<FirebaseFirestore>();
  var _recipesRepository = getIt<RecipesRepository>();

  Future<ReceptTags> init(String email) {
    usersCollection = email;
    return _loadTags();
  }

  ReceptTags getTags() {
    if (cachedTags == null) throw Exception("Repository not initialized");
    Set<String> listTagStringsFromRecipes = _recipesRepository.getRecipes().recipes.expand((e) => e.tags).toSet();
    Set<String> listTagStringsFromDatabase = cachedTags!.tags.map((e) => e.tag!).toSet();
    Set<String> allTagStrings = listTagStringsFromDatabase..addAll(listTagStringsFromRecipes);
    List<ReceptTag> allTags = allTagStrings.map((e) => new ReceptTag(e)).toList();
    return ReceptTags(allTags);
  }

  ReceptTag? getTagByTag (String tag) {
    return getTags().tags.firstWhereOrNull((element) => element.tag==tag);
  }

  Future<void> saveTag(ReceptTag tag) async {
    var tags = getTags();
    var oldTag = tags.tags.firstWhereOrNull((element) => element.tag==tag.tag);
    if (oldTag!=null){
      tags.tags.remove(oldTag);
    }
    tags.tags.add(tag);
    return _saveTags(tags);
  }

  Future<void> _saveTags(ReceptTags tags) async {
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

  void setSampleTags() {
    _saveTags(_createSample());
  }

  ReceptTags _createSample() {
    return ReceptTags([
      ReceptTag("ontbijt"),
      ReceptTag("smoothie"),
      ReceptTag("lunch"),
      ReceptTag("avondeten")
    ]);
  }


  Future<ReceptTags> _loadTags() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final tags = ReceptTags.fromJson(jsonObj);
      cachedTags = tags;
      return tags;
    }
    return ReceptTags(List.empty());
  }

}
