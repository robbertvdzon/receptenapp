import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../GetItDependencies.dart';
import '../../Toggles.dart';
import '../../repositories/Repositories.dart';
import '../../repositories/UserRepository.dart';
import 'AllAppHomePage.dart';

class MainApp extends StatefulWidget {
  MainApp({Key? key}) : super(key: key) {}

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
              home: AllAppHomePage(title: 'Gutz'),
            );
          }
          return MaterialApp(
              home: SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()]));
        },
      );
}
