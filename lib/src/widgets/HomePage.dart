import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'IngredientsPage.dart';

class HomePage extends StatefulWidget {
  FirebaseFirestore? db = null;
  late User user;

  HomePage(FirebaseFirestore? db, this.user, {Key? key, required this.title})
      : super(key: key) {
    this.db = db;
  }

  final String title;

  @override
  State<HomePage> createState() => _HomePageState(db, user);
}


class _HomePageState extends State<HomePage> {
  int _counter = 1;
  FirebaseFirestore? db = null;
  late User user;

  _HomePageState(FirebaseFirestore? db, this.user) {
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
                          IngredientsPage(db, user, title: 'Ingredienten')),
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

