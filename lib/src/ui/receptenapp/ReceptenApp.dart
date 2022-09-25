import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/ui/receptenapp/search/SearchRecipesPage.dart';
import '../../GetItDependencies.dart';
import '../../repositories/Repositories.dart';
import '../../repositories/UserRepository.dart';
import '../../services/GlobalStateService.dart';

const DISABLE_AUTH = true;

class ReceptenApp extends StatefulWidget {
  ReceptenApp({Key? key}) : super(key: key) {}

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ReceptenApp> {
  late StreamSubscription<User?> user;
  var userRepository = getIt<UserRepository>();
  var repositories = getIt<Repositories>();
  var globalStateService = getIt<GlobalStateService>();

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
            globalStateService.init();
            repositories.initRepositories();
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.blue,
              ),
              home: SearchRecipesPage(title: 'Recepten'),
            );
          }
          return MaterialApp(
              home: SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()]));
        },
      );
}
