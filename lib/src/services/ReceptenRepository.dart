import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../global.dart';
import '../model/model.dart';

class ReceptenRepository {
  var _db = getIt<FirebaseFirestore>();

  void addReceptenbookIfNeeded() {
    _db.collection("data").doc("receptenboeken").get().then((event) {
      var data = event.data();
      if (data == null) {
        final sample = createSample();
        final Map<String, dynamic> json = sample.toJson();
        final receptenboeken = <String, String>{"robbert": jsonEncode(json)};
        _db
            .collection("data")
            .doc("receptenboeken")
            .set(receptenboeken)
            .onError((e, _) => print("Error writing document: $e"));
        print("sample book interted");
      }
    });
  }

  void updateJson(String json) {
    final receptenboeken = <String, String>{"robbert": json};
    _db
        .collection("data")
        .doc("receptenboeken")
        .set(receptenboeken)
        .onError((e, _) => print("Error writing document: $e"));
    print("sample book interted");
  }

  void printReceptenbook() {
    print("read boek");
    _db.collection("data").doc("receptenboeken").get().then((event) {
      print("read boek2");
      print(event);
      Map<String, dynamic>? data = event.data();
      if (data != null) {
        var robbert = data["robbert"];
        var json = robbert as String;
        var jsonObj = jsonDecode(json);
        final receptenboek = ReceptenBoek.fromJson(jsonObj);
        print(receptenboek);
      }
      print(data);
    });
  }

  Future<String> loadReceptenbook() async {
    final event = await _db.collection("data").doc("receptenboeken").get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var robbert = data["robbert"];
      var json = robbert as String;
      return json;
    }
    return "?";
  }

  ReceptenBoek createSample() {
    final patat = Ingredient("patat");
    final hamburger = Ingredient("hamburger");
    final brood = Ingredient("brood");
    final boter = Ingredient("boter");
    final kaas = Ingredient("kaas");
    final hamburgermenu = Recept([patat, hamburger, brood], "hamburgermenu");
    final broodjeKaas = Recept([brood, boter, kaas], "broodje kaas");
    final receptenboek = ReceptenBoek(
        [hamburgermenu, broodjeKaas],
        [
          patat, hamburger, brood, boter, kaas,
        ]
    );
    return receptenboek;
  }

}
