import 'package:flutter/material.dart';
import 'package:receptenapp/src/GetItDependencies.dart';
import 'dart:async';

import 'package:receptenapp/src/ui/mainapp/AllApp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MainApp());
}


