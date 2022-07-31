import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/NutrientsRepository.dart';
import '../services/ReceptenRepository.dart';
import '../services/UserRepository.dart';
import 'IngredientItemWidget.dart';
import 'NutrientItemWidget.dart';

class IngredientsPage extends StatefulWidget {
  IngredientsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List<Ingredient> ingredients = List.empty();
  List<Ingredient> filteredIngredients = List.empty();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _filterTextFieldController = TextEditingController();
  var receptenRepository = getIt<ReceptenRepository>();
  String _filter = "";
  String codeDialog ="";
  String valueText = "";

  _IngredientsPageState() {
    receptenRepository.loadReceptenbook().then((value) => {
      setState(() {
        ingredients = value.ingredienten;
        filteredIngredients = ingredients.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
      })
    });
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterNutrients();
    });
  }

  void addNutrient(String name) {
    receptenRepository.addIngredient(name).then((value) => {
      setState(() {
        ingredients = value.ingredienten;
        filteredIngredients = ingredients.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
      })
    });

  }

  void _filterNutrients() {
    filteredIngredients = ingredients.where((element) => element.name!=null && element.name!.toLowerCase().contains(_filter.toLowerCase())).toList();
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
              decoration: InputDecoration(border: InputBorder.none, labelText: 'Filter: (${filteredIngredients.length} ingredienten)'),
              autofocus: true,
              controller: _filterTextFieldController..text = '$_filter',
              onChanged: (text) => {_updateFilter(text)},
            )
            ,
            SizedBox(
              height: 750,
              child: ListView(
                children: filteredIngredients.map((strone) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 100.0,
                          ),
                          color: Colors.white60,
                          alignment: Alignment.center,
                          child:
                          IngredientItemWidget(ingredient: strone),
                        ),
                      ],

                    ),

                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(15),
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
        tooltip: 'Add nutrient',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
