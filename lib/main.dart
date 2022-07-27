import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:receptenapp/src/global.dart';
import 'package:receptenapp/src/services/ReceptenRepository.dart';
import 'package:receptenapp/src/services/UserRepository.dart';
import 'package:receptenapp/src/widgets/ReceptenApp.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  addSampleWhenNeeded();

  runApp(ReceptenApp());
}

void addSampleWhenNeeded() {
  var appRepository = getIt<ReceptenRepository>();
  appRepository.addReceptenbookIfNeeded();
  appRepository.printReceptenbook();
}

Future<void> setupDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<ReceptenRepository>(ReceptenRepository());
  getIt.registerSingleton<UserRepository>(UserRepository());
}


