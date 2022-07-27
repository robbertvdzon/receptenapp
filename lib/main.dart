import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:receptenapp/src/services/AppRepository.dart';
import 'package:receptenapp/src/widgets/ReceptenApp.dart';
import 'firebase_options.dart';
import 'dart:async';

import 'src/utils/helpers.dart';

final _getIt = GetIt.instance;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  var appRepository = _getIt<AppRepository>();

  appRepository.addReceptenbookIfNeeded();
  appRepository.printReceptenbook();

  runApp(ReceptenApp());
}

Future<void> setupDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  _getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  _getIt.registerSingleton<AppRepository>(AppRepository());
}


