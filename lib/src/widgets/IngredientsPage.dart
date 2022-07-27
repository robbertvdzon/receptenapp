import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../global.dart';
import '../services/ReceptenRepository.dart';
import '../services/UserRepository.dart';

class IngredientsPage extends StatefulWidget {

  IngredientsPage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<IngredientsPage> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<IngredientsPage> {
  String _ingredientenJson = "?";
  var appRepository = getIt<ReceptenRepository>();
  var userRepository = getIt<UserRepository>();

  _MyHomePageState2() {
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

  void _incrementCounter() {
    setState(() {
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
                padding: EdgeInsets.all(20),


                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  Center(
                    child: Text(
                      'Sooraj S Nair',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                  Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a gallery of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum,It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  Center(
                    child: Text(
                      'Sooraj S Nair',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                  Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a gallery of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum,It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  Center(
                    child: Text(
                      'Sooraj S Nair',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                  Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a gallery of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum,It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
