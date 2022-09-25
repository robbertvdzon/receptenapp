import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../GetItDependencies.dart';
import '../../Toggles.dart';
import '../../repositories/Repositories.dart';
import '../../repositories/UserRepository.dart';
import '../../services/AppStateService.dart';
import 'PlannerHomePage.dart';

class PlannerApp extends StatefulWidget {
  PlannerApp({Key? key}) : super(key: key) {}

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PlannerApp> {
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
              home: PlannerHomePage(title: 'Planner'),
            );
          }
          return MaterialApp(
              home: SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()]));
        },
      );
}
