import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/ReceptenRepository.dart';
import '../services/UserRepository.dart';

class IngredientsPage extends StatefulWidget {
  IngredientsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<IngredientsPage> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<IngredientsPage> {
  String _ingredientenJson = "?";
  ReceptenBoek receptenBoek = ReceptenBoek(List.empty(), List.empty());
  var appRepository = getIt<ReceptenRepository>();
  var userRepository = getIt<UserRepository>();

  _MyHomePageState2() {
    appRepository.loadReceptenbook().then((value) => {
          setState(() {
            _ingredientenJson = value;
            receptenBoek = appRepository.createSample();
          })
        });
  }

  void _updateJson(String json) {
    print("UPDATING");
    print("start insert sample boek $json");
    appRepository.updateJson(json);
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
            Text(
              'user: ${userRepository.getUser()?.email}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Ingredienten:',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 400,
              child: ListView(
                children: receptenBoek.ingredienten.map((strone) {
                  return Container(
                    child: Text(strone.name),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(15),
                    // color: Colors.green[100],
                  );
                }).toList(),
              ),
            ),
            // TextFormField(
            //     decoration: InputDecoration(border: InputBorder.none),
            //     autofocus: true,
            //     keyboardType: TextInputType.multiline,
            //     maxLines: null,
            //     // initialValue: '$_ingredientenJson',
            //     controller: TextEditingController()
            //       ..text = '$_ingredientenJson',
            //     onChanged: (text) => {_updateJson(text)}
            //     // controller: _noteController
            //     ),
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
