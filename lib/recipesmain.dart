import 'package:flutter/material.dart';
import 'package:receptenapp/src/GetItDependencies.dart';
import 'package:receptenapp/src/ui/receptenapp/ReceptenApp.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(ReceptenApp());
}


