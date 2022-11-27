import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import '../GetItDependencies.dart';
import '../model/snacks/v1/snack.dart';

class SnacksRepository {
  String? usersCollection = null;
  Snacks? cachedSnacks = null;

  final String _DOCNAME = "snacks";
  final String _KEY = "v1";
  var _db = getIt<FirebaseFirestore>();

  Future<Snacks> init(String email) {
    usersCollection = email;
    return _loadSnacks();
  }

  Snacks getSnacks() {
    if (cachedSnacks == null) throw Exception("Repository not initialized");
    return cachedSnacks!;
  }

  Snack? getSnackByName (String name) {
    return getSnacks().snacks.firstWhereOrNull((element) => element.name==name);
  }

  Snack? getSnackByUuid (String uuid) {
    return getSnacks().snacks.firstWhereOrNull((element) => element.uuid==uuid);
  }

  Future<void> saveSnack(Snack snack) async {
    var snacks = getSnacks();
    var oldSnack = snacks.snacks.firstWhereOrNull((element) => element.uuid==snack.uuid);
    if (oldSnack!=null){
      snacks.snacks.remove(oldSnack);
    }
    snacks.snacks.add(snack);
    return _saveSnacks(snacks);
  }

  Future<void> removeSnack(String uuid) async {
    var snacks = getSnacks();
    var oldSnack = snacks.snacks.firstWhereOrNull((element) => element.uuid==uuid);
    if (oldSnack!=null){
      snacks.snacks.remove(oldSnack);
    }
    return _saveSnacks(snacks);
  }

  Future<void> addSnack(Snack snack) async {
    var snacks = getSnacks();
    snacks.snacks.add(snack);
    return _saveSnacks(snacks);
  }

  Future<void> _saveSnacks(Snacks snacks) async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final Map<String, dynamic> jsonMap = snacks.toJson();
    final jsonKeyValue = <String, String>{_KEY: jsonEncode(jsonMap)};
    return _db
        .collection(usersCollection!)
        .doc(_DOCNAME)
        .set(jsonKeyValue)
        .onError((e, _) => print("Error writing document: $e"))
        .then((data) => cachedSnacks = snacks);
  }

  Future<Snacks> _loadSnacks() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final snacks = Snacks.fromJson(jsonObj);
      cachedSnacks = snacks;
    }
    else{
      cachedSnacks = Snacks(List.empty(growable: true));
    }
    return cachedSnacks!;
  }

}



