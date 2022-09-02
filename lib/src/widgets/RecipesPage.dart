import 'package:flutter/material.dart';
import 'dart:async';
import '../global.dart';
import '../model/recept.dart';
import '../services/ProductsRepository.dart';
import '../services/RecipesRepository.dart';
import 'ReceptItemWidget.dart';

class RecipesPage extends StatefulWidget {
  RecipesPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<Recept> recipes = List.empty();
  List<Recept> filteredRecipes = List.empty();
  List<String> products = List.empty();

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _filterTextFieldController = TextEditingController();
  var recipesRepository = getIt<RecipesRepository>();
  var nutrientsRepository = getIt<ProductsRepository>();
  String _filter = "";
  String codeDialog ="";
  String valueText = "";

  _RecipesPageState() {
    recipes = recipesRepository.getRecipes().recipes;
    filteredRecipes = recipes.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
    products = nutrientsRepository.getProducts().products.map((e) => e.name ?? "").toList();
  }


  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterNutrients();
    });
  }

  void addNutrient(String name) {
    recipesRepository.createAndAddRecept(name).then((value) => {
      setState(() {
        recipes = recipesRepository.getRecipes().recipes;
        filteredRecipes = recipes.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
      })
    });

  }

  void _filterNutrients() {
    filteredRecipes = recipes.where((element) => element.name!=null && element.name!.toLowerCase().contains(_filter.toLowerCase())).toList();
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
                  addNutrient(valueText);
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(key: Key(_filter.toString()),
              decoration: InputDecoration(border: InputBorder.none, labelText: 'Filter: (${filteredRecipes.length} ingredienten)'),
              autofocus: true,
              controller: _filterTextFieldController..text = '$_filter',
              onChanged: (text) => {_updateFilter(text)},
            )
            ,
            SizedBox(
              height: 750,
              child: ListView(
                children: filteredRecipes.map((item) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 30.0,
                          ),
                          alignment: Alignment.center,
                          child:
                          ReceptItemWidget(recept: item),
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
        tooltip: 'Add nutrient',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
