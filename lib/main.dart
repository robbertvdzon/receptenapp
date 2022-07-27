import 'dart:convert';

import 'package:flutter/material.dart';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:receptenapp/src/model.dart';
import 'firebase_options.dart';
import 'package:uuid/uuid.dart';

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
// part 'main.g.dart';

// main() => runApp(const MyApp());

// void main() {
//   runApp(const MyApp());
// }

var uuid = Uuid();

void addReceptenbookIfNeeded(FirebaseFirestore db) {
  print("test boek");
  db.collection("data").doc("receptenboeken").get().then((event) {
    print("test boek2");
    print(event);
    var data = event.data();
    if (data == null) {
      print("insert sample boek");
      final sample = createSample();
      final Map<String, dynamic> json = sample.toJson();
      final receptenboeken = <String, String>{"robbert": jsonEncode(json)};

      print("start insert sample boek $json");
      db
          .collection("data")
          .doc("receptenboeken")
          .set(receptenboeken)
          .onError((e, _) => print("Error writing document: $e"));
      print("sample book interted");
    }
    print(data);
  });
}

void printReceptenbook(FirebaseFirestore db) {
  print("read boek");
  db.collection("data").doc("receptenboeken").get().then((event) {
    print("read boek2");
    print(event);
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var robbert = data["robbert"];
      var json = robbert as String;
      var jsonObj = jsonDecode(json);
      final receptenboek = ReceptenBoek.fromJson(jsonObj);
      print(receptenboek);
    }
    print(data);
  });
}

Future<String> loadReceptenbook(FirebaseFirestore db) async {
  print("read boek");
  final event = await db.collection("data").doc("receptenboeken").get();
  print("read boek2");
  print(event);
  Map<String, dynamic>? data = event.data();
  if (data != null) {
    var robbert = data["robbert"];
    var json = robbert as String;
    return json;
  }
  return "?";
}

ReceptenBoek createSample() {
  final patat = Ingredient("patat");
  final hamburger = Ingredient("hamburger");
  final brood = Ingredient("brood");
  final boter = Ingredient("boter");
  final kaas = Ingredient("kaas");
  final hamburgermenu = Recept([patat, hamburger, brood], "hamburgermenu");
  final broodjeKaas = Recept([brood, boter, kaas], "broodje kaas");
  final receptenboek = ReceptenBoek(
      [hamburgermenu, broodjeKaas], [patat, hamburger, brood, boter, kaas]);
  return receptenboek;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore db = FirebaseFirestore.instance;

  addReceptenbookIfNeeded(db);
  printReceptenbook(db);

  runApp(MyApp(db));
}

class MyApp extends StatelessWidget {
  FirebaseFirestore? db = null;

  MyApp(FirebaseFirestore? db, {Key? key}) : super(key: key) {
    this.db = db;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.blue,
              ),
              home: MyHomePage(db,snapshot.data!!, title: 'Flutter Demo Home Page'),
            );
          }
          return MaterialApp(
              home: SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()]));
        },
      );
}

class MyHomePage extends StatefulWidget {
  FirebaseFirestore? db = null;
  late User user;

  MyHomePage(FirebaseFirestore? db, this.user, {Key? key, required this.title})
      : super(key: key) {
    this.db = db;
  }

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(db, user);
}

class MyHomePage2 extends StatefulWidget {
  FirebaseFirestore? db = null;
  late User user;

  MyHomePage2(FirebaseFirestore? db, this.user, {Key? key, required this.title})
      : super(key: key) {
    this.db = db;
  }

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePageState2(db, user);
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  FirebaseFirestore? db = null;
  late User user;

  _MyHomePageState(FirebaseFirestore? db, this.user) {
    this.db = db;
    if (db != null) {
      db.collection("counter").doc("count").get().then((event) {
        var data = event.data();
        if (data != null) {
          var cnt = data.values.first;
          this._counter = cnt;
          setState(() {
            _counter = cnt;
          });
        }
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      final db = this.db;
      if (db != null) {
        final counter = <String, int>{"count": _counter};
        db
            .collection("counter")
            .doc("count")
            .set(counter)
            .onError((e, _) => print("Error writing document: $e"));
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              child: Text('Open ingredients'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage2(db, user, title: 'Ingredienten')),
                );
                print('Hello');
              },
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

class _MyHomePageState2 extends State<MyHomePage2> {
  String _ingredientenJson = "?";
  FirebaseFirestore? db = null;
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
