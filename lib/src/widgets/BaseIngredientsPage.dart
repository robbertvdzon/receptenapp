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
            TextFormField(
                key: Key(_filter.toString()),
                decoration: InputDecoration(border: InputBorder.none, labelText: 'Filter: (${filteredIngredients.length} ingredienten)'),
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                // initialValue: '$_ingredientenJson',
                controller: TextEditingController()
                  ..text = '$_filter',
                onChanged: (text) => {_updateFilter(text)},
              // controller: _noteController
            ),

            SizedBox(
              height: 400,
              child: ListView(
                children: filteredIngredients.map((strone) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 200.0,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.white60,
                          alignment: Alignment.center,
                          // transform: Matrix4.rotationZ(0.1),
                          child:                     Table(children: [
                            TableRow(children: [
                              Text("Naam"),
                              Text(":"),
                              Text(strone.name!),
                            ]),
                            TableRow(children:[Text("Eenheid"),Text(":"),Text(strone.quantity!),]),
                            TableRow(children:[Text("kcal"),Text(":"),Text(strone.kcal!),]),
                            TableRow(children:[Text("prot"),Text(":"),Text(strone.prot!),]),
                            TableRow(children:[Text("nt"),Text(":"),Text(strone.nt!),]),
                            TableRow(children:[Text("fat"),Text(":"),Text(strone.fat!),]),
                            TableRow(children:[Text("sugar"),Text(":"),Text(strone.sugar!),]),
                            TableRow(children:[Text("na"),Text(":"),Text(strone.na!),]),
                            TableRow(children:[Text("k"),Text(":"),Text(strone.k!),]),
                            TableRow(children:[Text("fe"),Text(":"),Text(strone.fe!),]),
                            TableRow(children:[Text("mg"),Text(":"),Text(strone.mg!),]),
                          ])
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
}
