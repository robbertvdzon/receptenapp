import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:receptenapp/src/services/AppRepository.dart';
import 'package:receptenapp/src/widgets/ReceptenApp.dart';
import 'firebase_options.dart';
import 'dart:async';

import 'src/utils/helpers.dart';


Future<void> main() async {

  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore db = FirebaseFirestore.instance;

  addReceptenbookIfNeeded(db);
  printReceptenbook(db);

  runApp(ReceptenApp(db));
}

void setup() {
  final getIt = GetIt.instance;

  getIt.registerSingleton<AppRepository>(AppRepository());
}


