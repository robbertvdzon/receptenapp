import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../global.dart';
import '../services/UserRepository.dart';
import 'HomePage.dart';

class ReceptenApp extends StatelessWidget {

  var userRepository = getIt<UserRepository>();

  ReceptenApp({Key? key}) : super(key: key) {
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userRepository.setUser(snapshot.data);
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.blue,
              ),
              home: HomePage(title: 'Flutter Demo Home Page'),
            );
          }
          return MaterialApp(
              home: SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()]));
        },
      );
}
