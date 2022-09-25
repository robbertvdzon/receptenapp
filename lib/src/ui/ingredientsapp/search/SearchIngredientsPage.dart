import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../events/IngredientCreatedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/ingredients/v1/ingredients.dart';
import '../../../services/AppStateService.dart';
import '../../../services/Enricher.dart';
import '../../../services/IngredientsService.dart';
import '../ingredients/IngredientEditPage.dart';
import '../ingredients/IngredientItemWidget.dart';
import '../ingredienttags/IngredientTagsPage.dart';
import '../products/SearchProductsPage.dart';

class SearchIngredientsPage extends StatefulWidget {
  SearchIngredientsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchIngredientsPage> createState() => _SearchIngredientsPageState();
}

class _SearchIngredientsPageState extends State<SearchIngredientsPage> {
  List<Ingredient> _filteredIngredients = List.empty();
  final _appStateService = getIt<AppStateService>();
  final _eventBus = getIt<EventBus>();
  String _filter = "";
  StreamSubscription? _eventStreamSub;

  @override
  void initState() {
    super.initState();
    _filterIngredients();
    _eventStreamSub = _eventBus.on<IngredientCreatedEvent>().listen((event) => _processEvent(event));
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _processEvent(IngredientCreatedEvent event) {
    setState(() {
      _filter = event.ingredient.name;
      _filterIngredients();
    });
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterIngredients();
    });
  }

  void _createNewIngredient() {
    Ingredient newIgredient = new Ingredient("Nieuw ingredient");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              IngredientEditPage(
                  title: 'Nieuw ingredient', ingredient: newIgredient)),
    );
  }

  void _filterIngredients() {
    List<Ingredient> ingredients = _getSortedListOfIngredients();
    _filteredIngredients = ingredients
        .where((element) =>
            element.name != null &&
            element.name.toLowerCase().contains(_filter.toLowerCase()))
        .toList();
  }

  List<Ingredient> _getSortedListOfIngredients() {
    List<Ingredient> ingredients = List.of(_appStateService.getIngredients());
    ingredients.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            child: Text('Producten'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SearchProductsPage(title: 'Producten')),
              );
            },
          ),
          SizedBox(width: 10),
          ElevatedButton(
            child: Text('Tags'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IngredientsTagsPage(title: 'Ingredient tags')),
              );
            },
          ),
          SizedBox(width: 10),
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout))
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 50,
                width: 500,
                child: TextFormField(
                  key: Key(_filter.toString()),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText:
                      'Filter: (${_filteredIngredients.length} ingredienten)'),
                  autofocus: true,
                  controller: TextEditingController()..text = '$_filter',
                  onChanged: (text) => {_updateFilter(text)},
                )
            ),
            SizedBox(
              height: 750,
              width: 500,
              child: ListView(
                children: _filteredIngredients.map((item) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 30.0,
                          ),
                          alignment: Alignment.center,
                          child: IngredientItemWidget(
                              ingredient: item,
                              key: ObjectKey(item)),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    // color: Colors.green[100],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewIngredient();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
