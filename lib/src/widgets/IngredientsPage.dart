import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../services/AppRepository.dart';
import '../utils/helpers.dart';

final getIt = GetIt.instance;

class IngredientsPage extends StatefulWidget {
  FirebaseFirestore? db = null;
  late User user;

  IngredientsPage(FirebaseFirestore? db, this.user, {Key? key, required this.title})
      : super(key: key) {
    this.db = db;
  }

  final String title;

  @override
  State<IngredientsPage> createState() => _MyHomePageState2(db, user);
}

class _MyHomePageState2 extends State<IngredientsPage> {
  String _ingredientenJson = "?";
  FirebaseFirestore? db = null;
  var myAppModel = getIt<AppRepository>();
  late User user;

  _MyHomePageState2(FirebaseFirestore? db, this.user) {
    this.db = db;
    if (db != null) {
      loadReceptenbook(db).then((value) => {
            setState(() {
              _ingredientenJson = value;
            })
          });
    }
  }

  void _updateJson(String json) {
    print("UPDATING");
    print("start insert sample boek $json");
    final receptenboeken = <String, String>{"robbert": json};
    final db = this.db;
    if (db != null) {
      db
          .collection("data")
          .doc("receptenboeken")
          .set(receptenboeken)
          .onError((e, _) => print("Error writing document: $e"));
      print("sample book interted");
    }
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
            Text(
              'user: ${user?.email}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Ingredienten:',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextFormField(
                decoration: InputDecoration(border: InputBorder.none),
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                // initialValue: '$_ingredientenJson',
                controller: TextEditingController()
                  ..text = '$_ingredientenJson',
                onChanged: (text) => {_updateJson(text)}
                // controller: _noteController
                ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
