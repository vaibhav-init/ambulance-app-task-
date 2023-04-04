// @dart=2.9

import 'package:ambulance_tracker/screens/ambulance_book.dart';
import 'package:ambulance_tracker/screens/choice_page.dart';
import 'package:ambulance_tracker/screens/loading_screen.dart';
import 'package:ambulance_tracker/screens/patient_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/Welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    ),
  );
}
