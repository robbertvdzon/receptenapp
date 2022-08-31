import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/TagsRepository.dart';
import '../services/ProductsRepository.dart';
import '../services/RecipesRepository.dart';
import '../services/UserRepository.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<CategoriesPage> createState() => _PageState();
}

class _PageState extends State<CategoriesPage> {
  List<String?> categories = List.empty();
  var tagsRepository = getIt<TagsRepository>();

  _PageState() {
    categories = tagsRepository.getTags().tags.map((e)=>e.tag).toList();
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
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
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
