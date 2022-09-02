import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../global.dart';
import '../../services/repositories/Repositories.dart';
import '../../services/repositories/UserRepository.dart';
import 'AllAppHomePage.dart';

const DISABLE_AUTH = true;

class AllApp extends StatefulWidget {
  AllApp({Key? key}) : super(key: key) {}

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AllApp> {
  late StreamSubscription<User?> user;
  var userRepository = getIt<UserRepository>();
  var repositories = getIt<Repositories>();

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData || DISABLE_AUTH) {
            print("START AFTER AUTH");
            userRepository.setUser(snapshot.data);
            repositories.initRepositories();
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.blue,
              ),
              home: AllAppHomePage(title: 'All app'),
            );
          }
          return MaterialApp(
              home: SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()]));
        },
      );
}