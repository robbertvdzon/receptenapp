import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

class ReceptenApp extends StatelessWidget {
  FirebaseFirestore? db = null;

  ReceptenApp(FirebaseFirestore? db, {Key? key}) : super(key: key) {
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
              home: HomePage(db,snapshot.data!!, title: 'Flutter Demo Home Page'),
            );
          }
          return MaterialApp(
              home: SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()]));
        },
      );
}