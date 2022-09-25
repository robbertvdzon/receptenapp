import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:receptenapp/src/repositories/IngredientsRepository.dart';
import '../../../GetItDependencies.dart';
import '../../../GlobalState.dart';
import '../../../model/ingredients/v1/ingredients.dart';
import '../../../repositories/ProductsRepository.dart';
import '../../../services/GlobalStateService.dart';
import '../../../services/IngredientsService.dart';
import '../../../services/ProductsService.dart';
import '../ingredienttags/IngredientTagsPage.dart';
import '../products/SearchProductsPage.dart';
import '../ingredients/IngredientItemWidget.dart';

class SearchIngredientsPage extends StatefulWidget {
  SearchIngredientsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchIngredientsPage> createState() => _SearchIngredientsPageState();
}

class _SearchIngredientsPageState extends State<SearchIngredientsPage> {
  List<Ingredient> _ingredients = List.empty();
  List<Ingredient> _filteredIngredients = List.empty();
  List<String> _products = List.empty();

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _filterTextFieldController = TextEditingController();
  var _globalStateService = getIt<GlobalStateService>();
  var _ingredientsService = getIt<IngredientsService>();
  String _filter = "";
  String codeDialog = "";
  String valueText = "";

  @override
  void initState() {
    super.initState();
    _ingredients = List.of(_globalStateService.getIngredients());
    _ingredients.sort((a, b) => a.name.compareTo(b.name));

    _filteredIngredients = _ingredients
        .where((element) =>
    element.name != null && element.name.contains(_filter))
        .toList();
    _products = _globalStateService.getProducts().map((e) => e.name ?? "").toList();
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterProducts();
    });
  }

  void addProduct(String name) {
    _ingredientsService.createAndAddIngredient(name).then((value) => {
          setState(() {
            _ingredients = List.of(_globalStateService.getIngredients());
            _ingredients.sort((a, b) => a.name.compareTo(b.name));
            _filteredIngredients = _ingredients
                .where((element) =>
                    element.name != null && element.name!.contains(_filter))
                .toList();
          })
        });
  }

  void _filterProducts() {
    _filteredIngredients = _ingredients
        .where((element) =>
            element.name != null &&
            element.name!.toLowerCase().contains(_filter.toLowerCase()))
        .toList();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  addProduct(valueText);
                  _updateFilter(valueText);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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
                  controller: _filterTextFieldController..text = '$_filter',
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
                              categories: _products,
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
          // _filterTextFieldController.text ="bla";
          // _incrementCounter(_filterTextFieldController);
          _displayTextInputDialog(context);
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
