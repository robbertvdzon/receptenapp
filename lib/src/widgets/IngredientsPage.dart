import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../services/AppRepository.dart';

final _getIt = GetIt.instance;

class IngredientsPage extends StatefulWidget {
  late User user;

  IngredientsPage(this.user, {Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<IngredientsPage> createState() => _MyHomePageState2(user);
}

class _MyHomePageState2 extends State<IngredientsPage> {
  String _ingredientenJson = "?";
  var appRepository = _getIt<AppRepository>();
  late User user;

  _MyHomePageState2(this.user) {
    appRepository.loadReceptenbook().then((value) => {
          setState(() {
            _ingredientenJson = value;
          })
        });
  }

  void _updateJson(String json) {
    print("UPDATING");
    print("start insert sample boek $json");
    appRepository.updateJson(json);
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
    );
  }
}
