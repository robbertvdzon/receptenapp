import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import '../GetItDependencies.dart';
import '../model/recipes/v1/recept.dart';

class RecipesRepository {
  String? usersCollection = null;
  Recipes? cachedRecipes = null;

  final String _DOCNAME = "recipes";
  final String _KEY = "v1";
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

  Future<void> addRecept(Recept recept) async {
    var recipes = getRecipes();
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
    final patat = ReceptIngredient("patat", amountGrams: ReceptIngredientAmountGrams(200));
    final hamburger = ReceptIngredient("hamburger", amountGrams: ReceptIngredientAmountGrams(200));
    final brood = ReceptIngredient("brood", amountGrams: ReceptIngredientAmountGrams(200));
    final boter = ReceptIngredient("boter", amountGrams: ReceptIngredientAmountGrams(200));
    final kaas = ReceptIngredient("kaas", amountGrams: ReceptIngredientAmountGrams(200));
    final hamburgermenu = Recept([patat, hamburger, brood], "Broodje hamburger");
    hamburgermenu.tags = ["zuivel","vlees","avondeten"];
    final broodjeKaas = Recept([brood, boter, kaas], "kaas broodje");
    broodjeKaas.tags = ["zuivel","vegatarisch","avondeten"];
//
    final noedelsoep = Recept([
      ReceptIngredient("gember", amountItems: ReceptIngredientAmountItems(0.1)),
      ReceptIngredient("knoflook", amountItems: ReceptIngredientAmountItems(1)),
      ReceptIngredient("eiernoedels", amountGrams: ReceptIngredientAmountGrams(200)),
      ReceptIngredient("zonnebloemolie", amountGrams: ReceptIngredientAmountGrams(50)),
      ReceptIngredient("water", amountGrams: ReceptIngredientAmountGrams(200)),
      ReceptIngredient("groentebouillontabletten", amountGrams: ReceptIngredientAmountGrams(30)),
      ReceptIngredient("sojasaus", amountGrams: ReceptIngredientAmountGrams(20)),
      ReceptIngredient("rijstazijn", amountGrams: ReceptIngredientAmountGrams(100)),
      ReceptIngredient("shitakes", amountGrams: ReceptIngredientAmountGrams(200)),
      ReceptIngredient("paksoi", amountItems:  ReceptIngredientAmountItems(1.5)),
      ReceptIngredient("sesamzaad", amountGrams: ReceptIngredientAmountGrams(15))
    ], "Noedelsoep met shiitake en paksoi");
    noedelsoep.directions = "Snijd de gember in dunne plakjes.\nSnijd de knoflook.\nKook de noedels..................";
    noedelsoep.tags = ["vlees","soep","avondeten"];
    noedelsoep.remark = "Was erg lekker en makkelijk!";
    noedelsoep.preparingTime = 10;
    noedelsoep.totalCookingTime = 45;
//
    final gnocchi = Recept([
      ReceptIngredient("amandelschaafsel", amountGrams: ReceptIngredientAmountGrams(10)),
      ReceptIngredient("olijfolie", amountItems: ReceptIngredientAmountItems(1)),
      ReceptIngredient("gnocchi", amountGrams: ReceptIngredientAmountGrams(1000)),
      ReceptIngredient("knoflook", amountItems: ReceptIngredientAmountItems(2)),
      ReceptIngredient("wilde spinazie", amountGrams: ReceptIngredientAmountGrams(400)),
      ReceptIngredient("hüttenkäse kaas", amountGrams: ReceptIngredientAmountGrams(200)),
      ReceptIngredient("verse basilicum", amountGrams: ReceptIngredientAmountGrams(20)),
      ReceptIngredient("Pecorino Romano", amountGrams: ReceptIngredientAmountGrams(100)),
      ReceptIngredient("cherrytomaten", amountGrams: ReceptIngredientAmountGrams(250)),
    ], "Gnoccchi met bassilliccum en tomaat");
    gnocchi.directions = "Verhit een koekenpan zonder olie of boter en rooster het amandelschaafsel 2 min.\nLaat afkoelen op een bord.\nVerhit 2/3 van de olie in de koekenpan en bak de gnocchi in 10 min. op middelhoog vuur goudbruin en gaar.\nSchep regelmatig om.\n\nSnijd ondertussen de knoflook fijn.\nVerhit de rest van de olie in een hapjespan en fruit de knoflook 30 sec.\nVoeg de spinazie in delen toe en laat al omscheppend slinken.\nMeng de hüttenkäse met peper door het spinaziemengsel en warm 2 min. mee.\nScheur de baslicumblaadjes in stukken en rasp de Pecorino Romano.\nSchep het basilicum, 2/3 van de Pecorino en gnocchi door de spinazie.\nHalveer de tomaten en voeg toe en bestrooi met het amandelschaafsel en de rest van de Pecorino.\n\nVariatietip:    Vervang voor een extra hartig accent het amandelschaafsel eens door 2 el kappertjes.";
    gnocchi.tags = ["vlees","soep","avondeten"];
    gnocchi.remark = "";
    gnocchi.preparingTime = 10;
    gnocchi.totalCookingTime = 45;



    final receptenboek = Recipes(
      [hamburgermenu,
        broodjeKaas,
        noedelsoep,
        gnocchi,
        createDummyRecept("recept 01"),
        createDummyRecept("recept 02"),
        createDummyRecept("recept 03"),
        createDummyRecept("recept 04"),
        createDummyRecept("recept 05"),
        createDummyRecept("recept 06"),
        createDummyRecept("recept 07"),
        createDummyRecept("recept 08"),
        createDummyRecept("recept 09"),
        createDummyRecept("recept 10"),
      ],
    );
    return receptenboek;
  }

  Recept createDummyRecept(String naam) => Recept([ReceptIngredient("hamburger"), ReceptIngredient("brood")], naam);


}



