import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';

import '../global.dart';
import '../model/model.dart';

class RecipesTagsRepository {
  final String _DOCNAME = "recipestags";
  final String _KEY = "data";
  String? usersCollection = null;

  Tags? cachedTags = null;

  var _db = getIt<FirebaseFirestore>();
  var _recipesRepository = getIt<RecipesRepository>();

  Future<Tags> init(String email) {
    usersCollection = email;
    return _loadTags();
  }

  Tags getTags() {
    if (cachedTags == null) throw Exception("Repository not initialized");
    Set<String> listTagStringsFromRecipes = _recipesRepository.getRecipes().recipes.expand((e) => e.tags).toSet();
    Set<String> listTagStringsFromDatabase = cachedTags!.tags.map((e) => e.tag!).toSet();
    Set<String> allTagStrings = listTagStringsFromDatabase..addAll(listTagStringsFromRecipes);
    List<Tag> allTags = allTagStrings.map((e) => new Tag(e)).toList();
    return Tags(allTags);
  }

  Tag? getTagByTag (String tag) {
    return getTags().tags.firstWhereOrNull((element) => element.tag==tag);
  }

  Future<void> saveTag(Tag tag) async {
    var tags = getTags();
    var oldTag = tags.tags.firstWhereOrNull((element) => element.tag==tag.tag);
    if (oldTag!=null){
      tags.tags.remove(oldTag);
    }
    tags.tags.add(tag);
    return saveTags(tags);
  }

  Future<void> saveTags(Tags tags) async {
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

  Future<Tag> createAndAddTag(String name) async {
    return _loadTags().then((tags) {
      final tag = Tag(name);
      tags.tags.add(tag);
      return saveTags(tags).then((value) => tag);
    });
  }

  void setSampleTags() {
    saveTags(_createSample());
  }

  Tags _createSample() {
    return Tags([
      Tag("ontbijt"),
      Tag("smoothie"),
      Tag("lunch"),
      Tag("avondeten")
    ]);
  }


  Future<Tags> _loadTags() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final tags = Tags.fromJson(jsonObj);
      cachedTags = tags;
      return tags;
    }
    return Tags(List.empty());
  }

}
