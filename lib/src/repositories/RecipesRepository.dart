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
    return _saveRecipes(recipes);
  }

  Future<void> removeRecept(String uuid) async {
    var recipes = getRecipes();
    var oldRecept = recipes.recipes.firstWhereOrNull((element) => element.uuid==uuid);
    if (oldRecept!=null){
      recipes.recipes.remove(oldRecept);
    }
    return _saveRecipes(recipes);
  }

  Future<void> addRecept(Recept recept) async {
    var recipes = getRecipes();
    recipes.recipes.add(recept);
    return _saveRecipes(recipes);
  }

  Future<void> _saveRecipes(Recipes recipes) async {
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
    _saveRecipes(_createSample());
  }
  
  Recipes _createSample() {
    final patat = ReceptIngredient("patat", amount: ReceptIngredientAmount(200,"g"));
    final hamburger = ReceptIngredient("hamburger", amount: ReceptIngredientAmount(200,"g"));
    final brood = ReceptIngredient("brood", amount: ReceptIngredientAmount(200,"g"));
    final boter = ReceptIngredient("boter", amount: ReceptIngredientAmount(200,"g"));
    final kaas = ReceptIngredient("kaas", amount: ReceptIngredientAmount(200,"g"));
    final hamburgermenu = Recept([patat, hamburger, brood], "Broodje hamburger");
    hamburgermenu.tags = ["zuivel","vlees","avondeten"];
    final broodjeKaas = Recept([brood, boter, kaas], "kaas broodje");
    broodjeKaas.tags = ["zuivel","vegatarisch","avondeten"];
//
    final noedelsoep = Recept([
      ReceptIngredient("gember", amount: ReceptIngredientAmount(0.1,"stuks")),
      ReceptIngredient("knoflook", amount: ReceptIngredientAmount(1,"stuks")),
      ReceptIngredient("eiernoedels", amount: ReceptIngredientAmount(200,"g")),
      ReceptIngredient("zonnebloemolie", amount: ReceptIngredientAmount(50,"g")),
      ReceptIngredient("water", amount: ReceptIngredientAmount(200,"g")),
      ReceptIngredient("groentebouillontabletten", amount: ReceptIngredientAmount(30,"g")),
      ReceptIngredient("sojasaus", amount: ReceptIngredientAmount(20,"g")),
      ReceptIngredient("rijstazijn", amount: ReceptIngredientAmount(100,"g")),
      ReceptIngredient("shitakes", amount: ReceptIngredientAmount(200,"g")),
      ReceptIngredient("paksoi", amount:  ReceptIngredientAmount(1.5,"stuks")),
      ReceptIngredient("sesamzaad", amount: ReceptIngredientAmount(15,"g"))
    ], "Noedelsoep met shiitake en paksoi");
    noedelsoep.instructions = "Snijd de gember in dunne plakjes.\nSnijd de knoflook.\nKook de noedels..................";
    noedelsoep.tags = ["vlees","soep","avondeten"];
    noedelsoep.remark = "Was erg lekker en makkelijk!";
    noedelsoep.preparingTime = 10;
    noedelsoep.totalCookingTime = 45;
//
    final gnocchi = Recept([
      ReceptIngredient("amandelschaafsel", amount: ReceptIngredientAmount(10,"g")),
      ReceptIngredient("olijfolie", amount: ReceptIngredientAmount(1,"stuks")),
      ReceptIngredient("gnocchi", amount: ReceptIngredientAmount(1000,"g")),
      ReceptIngredient("knoflook", amount: ReceptIngredientAmount(2,"stuks")),
      ReceptIngredient("wilde spinazie", amount: ReceptIngredientAmount(400,"g")),
      ReceptIngredient("hüttenkäse kaas", amount: ReceptIngredientAmount(200,"g")),
      ReceptIngredient("verse basilicum", amount: ReceptIngredientAmount(20,"g")),
      ReceptIngredient("Pecorino Romano", amount: ReceptIngredientAmount(100,"g")),
      ReceptIngredient("cherrytomaten", amount: ReceptIngredientAmount(250,"g")),
    ], "Gnoccchi met bassilliccum en tomaat");
    gnocchi.instructions = "Verhit een koekenpan zonder olie of boter en rooster het amandelschaafsel 2 min.\nLaat afkoelen op een bord.\nVerhit 2/3 van de olie in de koekenpan en bak de gnocchi in 10 min. op middelhoog vuur goudbruin en gaar.\nSchep regelmatig om.\n\nSnijd ondertussen de knoflook fijn.\nVerhit de rest van de olie in een hapjespan en fruit de knoflook 30 sec.\nVoeg de spinazie in delen toe en laat al omscheppend slinken.\nMeng de hüttenkäse met peper door het spinaziemengsel en warm 2 min. mee.\nScheur de baslicumblaadjes in stukken en rasp de Pecorino Romano.\nSchep het basilicum, 2/3 van de Pecorino en gnocchi door de spinazie.\nHalveer de tomaten en voeg toe en bestrooi met het amandelschaafsel en de rest van de Pecorino.\n\nVariatietip:    Vervang voor een extra hartig accent het amandelschaafsel eens door 2 el kappertjes.";
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



