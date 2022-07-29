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
  var baseIngredientsRepository = getIt<BaseIngredientsRepository>();
  var userRepository = getIt<UserRepository>();

  _BaseIngredientsPageState() {
    baseIngredientsRepository.loadBaseIngredients().then((value) => {
          setState(() {
            baseIngredients = value;
          })
        });
  }

  void _updateJson(String json) {
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
              'Base Ingredienten:',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 400,
              child: ListView(
                children: baseIngredients.ingredienten.map((strone) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Text("naam:"+strone.name!),
                        Text("eenheid:"+strone.quantity!),
                        Text("kcal:"+strone.kcal!),
                        Text("prot:"+strone.prot!),
                        Text("nt:"+strone.nt!),
                        Text("fat:"+strone.fat!),
                        Text("sugar:"+strone.sugar!),
                        Text("na:"+strone.na!),
                        Text("k:"+strone.k!),
                        Text("fe:"+strone.fe!),
                        Text("mg:"+strone.mg!),
                        Container(
                          constraints: BoxConstraints.expand(
                            height: Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 200.0,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.blue[600],
                          alignment: Alignment.center,
                          // transform: Matrix4.rotationZ(0.1),
                          child:                     Table(children: [
                            TableRow(children: [
                              Text("Naam"),
                              Text(":"),
                              Text(strone.name!),
                            ]),
                            TableRow(children:[
                              Text("Eenheid"),
                              Text(":"),
                              Text(strone.quantity!),
                            ]),
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
