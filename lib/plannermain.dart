import 'package:flutter/material.dart';
import 'package:receptenapp/src/global.dart';
import 'package:receptenapp/src/ui/plannerapp/PlannerApp.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(PlannerApp());
}



