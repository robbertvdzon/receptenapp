import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../global.dart';
import '../model/model.dart';
import 'UserRepository.dart';

class TagsRepository {

  final String _DOCNAME = "tags";
  final String _KEY = "data";

  var _db = getIt<FirebaseFirestore>();
  var _userRepository = getIt<UserRepository>();

  void printTags() {
    loadTags().then((data) =>
      print(data)
    );
    }

  Future<Tags> loadTags() async {
    final email = _userRepository.getUsersEmail();
    final event = await _db.collection(email).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final ingredientCategories = Tags.fromJson(jsonObj);
      return ingredientCategories;
    }
    return Tags(List.empty());
  }

  void saveTags(Tags tags) {
    final email = _userRepository.getUsersEmail();
    final Map<String, dynamic> json = tags.toJson();
    final receptenBoekJson = <String, String>{_KEY: jsonEncode(json)};
    _db
        .collection(email)
        .doc(_DOCNAME)
        .set(receptenBoekJson)
        .onError((e, _) => print("Error writing document: $e"));
    print("ingredientCategories saves");

  }


}
