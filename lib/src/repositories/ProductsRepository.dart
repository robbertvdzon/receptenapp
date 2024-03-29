import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';

import '../GetItDependencies.dart';
import '../model/products/v1/products.dart';



class ProductsRepository {
  String? usersCollection = null;
  Products? cachedProducts = null;

  final _DOCNAME = "products";
  final _KEY = "v1";
  var _db = getIt<FirebaseFirestore>();
  var _ingredientsRepository = getIt<IngredientsRepository>();

  Future<Products> init(String email) {
    usersCollection = email;
    return _loadProducts();
  }

  Products getProducts() {
    if (cachedProducts == null) throw Exception("Repository not initialized");
    Set<String?> allProductsFromIngredients = _ingredientsRepository.getIngredients().ingredients.map((e) => e.productName).toSet();
    var combinedProducts = cachedProducts!.products;
    allProductsFromIngredients.forEach((product) {
      if (combinedProducts.where((element) => element.name==product).isEmpty){
        combinedProducts.add(Product(product));
      }
    });
    return Products(combinedProducts);

  }

  Product? getProductByName (String name) {
    return getProducts().products.firstWhereOrNull((element) => element.name==name);
  }

  Future<void> saveProduct(Product product) async {
    var products = getProducts();
    var oldProduct = products.products.firstWhereOrNull((element) => element.name==product.name);
    if (oldProduct!=null){
      products.products.remove(oldProduct);
    }
    products.products.add(product);
    return _saveProducts(products);
  }

  Future<void> addProduct(Product product) async {
    var products = getProducts();
    products.products.add(product);
    return _saveProducts(products);
  }

  Future<void> _saveProducts(Products products) async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final Map<String, dynamic> jsonMap = products.toJson();
    final jsonKeyValue = <String, String>{_KEY: jsonEncode(jsonMap)};
    return _db
        .collection(usersCollection!)
        .doc(_DOCNAME)
        .set(jsonKeyValue)
        .onError((e, _) => print("Error writing document: $e"))
        .then((data) => cachedProducts = products);
  }
  void setSampleProducts() async {
    final sample = await _readPreloadedProducts();
    _saveProducts(sample);
  }

  Future<Products> _readPreloadedProducts() async {
    final String response = await rootBundle.loadString('assets/NEVO2021.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(fieldDelimiter: "|").convert(response);

    final List<Product> list = rowsAsListOfValues.skip(1).map((element) => parseToProducts(element)).toList();
    print("added:"+list.length.toString());
    return Products(list);
  }

  Product parseToProducts(List<dynamic> element) {


    final bi = Product(element[4]);
    bi.kcal = double.parse("2,3".replaceAll(",", "."));

    bi.category = element[1];
    bi.nevoCode = element[3];
    bi.quantity = double.tryParse(element[7].replaceAll(",", "."));
    bi.kcal = double.tryParse(element[12].replaceAll(",", "."));
    bi.prot = double.tryParse(element[14].replaceAll(",", "."));
    bi.nt = double.tryParse(element[17].replaceAll(",", "."));
    bi.fat = double.tryParse(element[18].replaceAll(",", "."));
    bi.sugar = double.tryParse(element[27].replaceAll(",", "."));
    bi.na = double.tryParse(element[35].replaceAll(",", "."));
    bi.k = double.tryParse(element[36].replaceAll(",", "."));
    bi.fe = double.tryParse(element[40].replaceAll(",", "."));
    bi.mg = double.tryParse(element[39].replaceAll(",", "."));
    bi.customProduct = false;
    return bi;
  }
  

  Future<Products> _loadProducts() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final products = Products.fromJson(jsonObj);
      cachedProducts = products;
      return products;
    }
    return Products(List.empty());
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
