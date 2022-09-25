import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../repositories/ProductsRepository.dart';
import '../../../repositories/RecipesRepository.dart';
import '../../../services/GlobalStateService.dart';
import '../recepts/ReceptItemWidget.dart';
import '../recepttags/RecipesTagsPage.dart';

class SearchRecipesPage extends StatefulWidget {
  SearchRecipesPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchRecipesPage> createState() => _SearchRecipesPageState();
}

class _SearchRecipesPageState extends State<SearchRecipesPage> {
  List<Recept> recipes = List.empty();

  // List<Recept> filteredRecipes = List.empty();
  List<String> products = List.empty();

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _filterTextFieldController = TextEditingController();
  var _recipesRepository = getIt<RecipesRepository>();
  var _productsRepository = getIt<ProductsRepository>();
  var _globalStateService = getIt<GlobalStateService>();
  String _filter = "";
  bool? _filterOnFavorite = false;
  String _valueText = "";

  @override
  void initState() {
    super.initState();
    recipes = _recipesRepository.getRecipes().recipes;
    recipes.sort((a, b) => a.name.compareTo(b.name));

    _globalStateService.setFilteredRecipes(recipes
        .where((element) =>
            element.name != null && element.name!.contains(_filter))
        .toList());
    products = _productsRepository
        .getProducts()
        .products
        .map((e) => e.name ?? "")
        .toList();
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterProducts();
    });
  }

  void _updateFilterOnFavorite(bool? filterOnFavorite) {
    setState(() {
      _filterOnFavorite = filterOnFavorite;
      _filterProducts();
    });
  }

  void addProduct(String name) {
    _recipesRepository.createAndAddRecept(name).then((value) => {
          setState(() {
            recipes = _recipesRepository.getRecipes().recipes;
            _globalStateService.setFilteredRecipes(recipes
                .where((element) =>
                    element.name != null && element.name!.contains(_filter))
                .toList());
          })
        });
  }

  void _filterProducts() {
    bool filterOnFavorite = _filterOnFavorite == true;

    // TODO: dit kan vast in 1 query!
    if (filterOnFavorite) {
      _globalStateService.setFilteredRecipes(recipes
          .where((element) =>
              element.favorite &&
              element.name != null &&
              element.name.toLowerCase().contains(_filter.toLowerCase()))
          .toList());
    } else {
      _globalStateService.setFilteredRecipes(recipes
          .where((element) =>
              element.name != null &&
              element.name.toLowerCase().contains(_filter.toLowerCase()))
          .toList());
    }
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
                  _valueText = value;
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
                  addProduct(_valueText);
                  _updateFilter(_valueText);
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
            child: Text('Zoek'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipesTagsPage(title: 'Zoek')),
              );
            },
          ),
          SizedBox(width: 10),
          ElevatedButton(
            child: Text('Recipes tags'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RecipesTagsPage(title: 'Recipes tags')),
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
                          'Quickfilter: (${_globalStateService.filteredRecipes().length} recepten)'),
                  autofocus: true,
                  controller: _filterTextFieldController..text = '$_filter',
                  onChanged: (text) => {_updateFilter(text)},
                )),
            SizedBox(
                height: 50,
                width: 500,
                child: CheckboxListTile(
                  checkColor: Colors.white,
                  title: Text("Filter op favoriet"),
                  value: _filterOnFavorite,
                  onChanged: (bool? value) {
                    _updateFilterOnFavorite(value);
                  },
                )),
            SizedBox(
              height: 750,
              width: 500,
              child: ListView(
                children: _globalStateService.filteredRecipes().map((item) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 150.0,
                          ),
                          alignment: Alignment.center,
                          child: ReceptItemWidget(
                              recept: item, key: ObjectKey(item)),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
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
