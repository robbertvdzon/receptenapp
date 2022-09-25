import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/services/AppStateService.dart';
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
  var _userRepository = getIt<UserRepository>();
  var _repositories = getIt<Repositories>();
  var _appStateService = getIt<AppStateService>();

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
            _userRepository.setUser(snapshot.data);
            _appStateService.init();
            _repositories.initRepositories();
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
