import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:receptenapp/src/model/model.dart';
import '../firebase_options.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


void addReceptenbookIfNeeded(FirebaseFirestore db) {
  print("test boek");
  db.collection("data").doc("receptenboeken").get().then((event) {
    print("test boek2");
    print(event);
    var data = event.data();
    if (data == null) {
      print("insert sample boek");
      final sample = createSample();
      final Map<String, dynamic> json = sample.toJson();
      final receptenboeken = <String, String>{"robbert": jsonEncode(json)};

      print("start insert sample boek $json");
      db
          .collection("data")
          .doc("receptenboeken")
          .set(receptenboeken)
          .onError((e, _) => print("Error writing document: $e"));
      print("sample book interted");
    }
    print(data);
  });
}

void printReceptenbook(FirebaseFirestore db) {
  print("read boek");
  db.collection("data").doc("receptenboeken").get().then((event) {
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

Future<String> loadReceptenbook(FirebaseFirestore db) async {
  print("read boek");
  final event = await db.collection("data").doc("receptenboeken").get();
  print("read boek2");
  print(event);
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
      [hamburgermenu, broodjeKaas], [patat, hamburger, brood, boter, kaas]);
  return receptenboek;
}

