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

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<CategoriesPage> createState() => _PageState();
}

class _PageState extends State<CategoriesPage> {
  List<String?> categories = List.empty();
  var baseIngredientsRepository = getIt<BaseIngredientsRepository>();

  _PageState() {
    baseIngredientsRepository.loadBaseIngredients().then((value) => {
          setState(() {
            categories =
                value.ingredienten.map((e) => e.category).toSet().toList();
          })
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
            SizedBox(
              height: 400,
              child: ListView(
                children: categories.map((strone) {
                  return Container(
                    child: Text(strone??""),
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
    );
  }
}
