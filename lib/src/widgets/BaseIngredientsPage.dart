import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/BaseIngriedientsRepository.dart';
import '../services/ReceptenRepository.dart';
import '../services/UserRepository.dart';
import 'BaseIngredientsItemWidget.dart';

class BaseIngredientsPage extends StatefulWidget {
  BaseIngredientsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<BaseIngredientsPage> createState() => _BaseIngredientsPageState();
}

class _BaseIngredientsPageState extends State<BaseIngredientsPage> {
  BaseIngredients baseIngredients = BaseIngredients(List.empty());
  List<BaseIngredient> filteredIngredients = List.empty();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _filterTextFieldController = TextEditingController();
  var baseIngredientsRepository = getIt<BaseIngredientsRepository>();
  String _filter = "";
  String codeDialog ="";
  String valueText = "";

  _BaseIngredientsPageState() {
    baseIngredientsRepository.loadBaseIngredients().then((value) => {
          setState(() {
            baseIngredients = value;
            filteredIngredients = baseIngredients.ingredienten.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
          })
        });
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterIngredients();
    });
  }

  void addIngredient(String name) {
    baseIngredientsRepository.addIngredient(name).then((value) => {
      setState(() {
        baseIngredients = value;
        filteredIngredients = baseIngredients.ingredienten.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
      })
    });

  }

  void _filterIngredients() {
    filteredIngredients = baseIngredients.ingredienten.where((element) => element.name!=null && element.name!.toLowerCase().contains(_filter.toLowerCase())).toList();
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
                  addIngredient(valueText);
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
                            height: 750.0,
                          ),
                          color: Colors.white60,
                          alignment: Alignment.center,
                          child:
                        BaseIngredientsItemWidget(ingredient: strone),
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
        tooltip: 'Add ingredient',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
