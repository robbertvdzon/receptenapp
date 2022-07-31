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
  var baseIngredientsRepository = getIt<BaseIngredientsRepository>();
  String _filter = "";

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

  void _updateFormFilter(String text, String field) {
    print("_updateFormFilter : $field = $text");
  }


  void _filterIngredients() {
    filteredIngredients = baseIngredients.ingredienten.where((element) => element.name!=null && element.name!.toLowerCase().contains(_filter.toLowerCase())).toList();
  }

  void _incrementCounter() {
    setState(() {});
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
            buildSearchTextFormField(),
            SizedBox(
              height: 600,
              child: ListView(
                children: filteredIngredients.map((strone) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 600.0,
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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextFormField buildSearchTextFormField() {
    return TextFormField(
              key: Key(_filter.toString()),
              decoration: InputDecoration(border: InputBorder.none, labelText: 'Filter: (${filteredIngredients.length} ingredienten)'),
              autofocus: true,
              controller: TextEditingController()..text = '$_filter',
              onChanged: (text) => {_updateFilter(text)},
          );
  }

  TextFormField buildFieldTextFormField(String field, String fieldText) {
    return TextFormField(
              decoration: InputDecoration(border: InputBorder.none, labelText: field),
              controller: TextEditingController()..text = fieldText,
              onChanged: (text) => {_updateFormFilter(text, field)},
          );
  }

}
