import 'package:flutter/material.dart';
import 'package:swimplan/pages/wrapper.dart';
import 'package:swimplan/pages/accueil.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swim Plan',
      home: Menu(),
    );
  }
}
