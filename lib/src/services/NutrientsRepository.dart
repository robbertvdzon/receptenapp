import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart';

import '../global.dart';
import '../model/model.dart';

class NutrientsRepository {
  var _db = getIt<FirebaseFirestore>();

  void addNutrientsIfNeeded() {
    print("test base_ingredients");
    _db.collection("data").doc("nutrients").get().then((event) async {
      print(event);
      var data = event.data();
      if (data == null) {
        print("insert base nutrients");
        final sample = await readPreloadedNutrients();
        final Map<String, dynamic> json = sample.toJson();
        final baseIngredients = <String, String>{"robbert": jsonEncode(json)};
        print("start insert nutrients $baseIngredients");
        _db
            .collection("data")
            .doc("nutrients")
            .set(baseIngredients)
            .onError((e, _) => print("Error writing document: $e"));
        print("sample nutrients inserted");

      }
    });
  }

  Future<Nutrients> loadNutrients() async {
    final event = await _db.collection("data").doc("nutrients").get();
    print("read nutrients");
    print(event);
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var robbert = data["robbert"];
      var json = robbert as String;
      var jsonObj = jsonDecode(json);
      return Nutrients.fromJson(jsonObj);
    }
    return Nutrients(List.empty());
  }





  Future<Nutrients> readPreloadedNutrients() async {
    final String response = await rootBundle.loadString('NEVO2021.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(fieldDelimiter: "|").convert(response);

    final List<Nutrient> list = rowsAsListOfValues.skip(1).map((element) => parseToNutrients(element)).toList();
    return Nutrients(list);
  }

  Nutrient parseToNutrients(List<dynamic> element) {
    final bi = Nutrient(element[4]);
    bi.category = element[1];
    bi.nevoCode = element[3];
    bi.quantity = element[7];
    bi.kcal = element[12];
    bi.prot = element[14];
    bi.nt = element[17];
    bi.fat = element[18];
    bi.sugar = element[27];
    bi.na = element[35];
    bi.k = element[36];
    bi.fe = element[40];
    bi.mg = element[39];
    bi.customNutrient = false;
    return bi;
  }

  void saveNutrients(Nutrients baseIngredients) {
    final Map<String, dynamic> json = baseIngredients.toJson();
    final baseIngredientsJson = <String, String>{"robbert": jsonEncode(json)};

    _db
        .collection("data")
        .doc("nutrients")
        .set(baseIngredientsJson)
        .onError((e, _) => print("Error writing document: $e"));
    print("sample baseIngredients inserted");

  }

  Future<Nutrients> addNutrient(String name) async {
    return loadNutrients().then((ingredients) => _addNutrient(ingredients, name));
  }

  Future<Nutrients> _addNutrient(Nutrients baseIngredients, String name) async {
    final baseIngredient = Nutrient(name);
    baseIngredients.nutrients.add(baseIngredient);
    saveNutrients(baseIngredients);
    return baseIngredients;
  }


}

/*
NEVO-versie/NEVO-version
Voedingsmiddelgroep"
"Food group"
"NEVO-code"
4:"Voedingsmiddelnaam/Dutch food name"
"Engelse naam/Food name"
"Synoniem"
"Hoeveelheid/Quantity"
"Opmerking"
"Bevat sporen van/Contains traces of"
"Is verrijkt met/Is fortified with"
"ENERCJ (kJ)"
"ENERCC (kcal)"
"WATER (g)"
"PROT (g)"
"PROTPL (g)"
"PROTAN (g)"
"NT (g)"
"FAT (g)"
"FACID (g)"
"FASAT (g)"
"FAMSCIS (g)"
"FAPU (g)"
"FAPUN3 (g)"
"FAPUN6 (g)"
"FATRS (g)"
"CHO (g)"
"SUGAR (g)"
"STARCH (g)"
"POLYL (g)"
"FIBT (g)"
"ALC (g)"
"OA (g)"
"ASH (g)"
"CHORL (mg)"
"NA (mg)"
"K (mg)"
"CA (mg)"
"P (mg)"
"MG (mg)"
"FE (mg)"
"HAEM (mg)"
"NHAEM (mg)"
"CU (mg)"
"SE (µg)"
"ZN (mg)"
"ID (µg)"
"VITA_RAE (µg)"
"VITA_RE (µg)"|"RETOL (µg)"|"CARTBTOT (µg)"|"CARTA (µg)"|"LUTN (µg)"|"ZEA (µg)"|"CRYPXB (µg)"|"LYCPN (µg)"|"VITD (µg)"|"CHOCALOH (µg)"|"CHOCAL (µg)"|"VITE (mg)"|"TOCPHA (mg)"|"TOCPHB (mg)"|"TOCPHD (mg)"|"TOCPHG (mg)"|"VITK (µg)"|"VITK1 (µg)"|"VITK2 (µg)"|"THIA (mg)"|"RIBF (mg)"|"VITB6 (mg)"|"VITB12 (µg)"|"NIA (mg)"|"FOL (µg)"|"FOLFD (µg)"|"FOLAC (µg)"|"VITC (mg)"|"F4:0 (g)"|"F6:0 (g)"|"F8:0 (g)"|"F10:0 (g)"|"F11:0 (g)"|"F12:0 (g)"|"F13:0 (g)"|"F14:0 (g)"|"F15:0 (g)"|"F16:0 (g)"|"F17:0 (g)"|"F18:0 (g)"|"F19:0 (g)"|"F20:0 (g)"|"F21:0 (g)"|"F22:0 (g)"|"F23:0 (g)"|"F24:0 (g)"|"F25:0 (g)"|"F26:0 (g)"|"FASATXR (g)"|"F10:1CIS (g)"|"F12:1CIS (g)"|"F14:1CIS (g)"|"F16:1CIS (g)"|"F18:1CIS (g)"|"F20:1CIS (g)"|"F22:1CIS (g)"|"F24:1CIS (g)"|"FAMSCXR (g)"|"F18:2CN6 (g)"|"F18:2CN9 (g)"|"F18:2CT (g)"|"F18:2TC (g)"|"F18:2R (g)"|"F18:3CN3 (g)"|"F18:3CN6 (g)"|"F18:4CN3 (g)"|"F20:2CN6 (g)"|"F20:3CN9 (g)"|"F20:3CN6 (g)"|"F20:3CN3 (g)"|"F20:4CN6 (g)"|"F20:4CN3 (g)"|"F20:5CN3 (g)"|"F21:5CN3 (g)"|"F22:2CN6 (g)"|"F22:2CN3 (g)"|"F22:3CN3 (g)"|"F22:4CN6 (g)"|"F22:5CN6 (g)"|"F22:5CN3 (g)"|"F22:6CN3 (g)"|"F24:2CN6 (g)"|"FAPUXR (g)"|"F10:1TRS (g)"|"F12:1TRS (g)"|"F14:1TRS (g)"|"F16:1TRS (g)"|"F18:1TRS (g)"|"F18:2TTN6 (g)"|"F18:3TTTN3 (g)"|"F20:1TRS (g)"|"F20:2TT (g)"|"F22:1TRS (g)"|"F24:1TRS (g)"|"FAMSTXR (g)"|"FAUN (g)"

 */