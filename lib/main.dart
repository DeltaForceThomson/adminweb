import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authenticatication/login_screen.dart';
import 'homeScreen/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC7Mq5xAcg09euurmFHM-4InDQTejiqtAM",
          appId: "1:407419807208:web:f0b2653afcf8936409f05d",
          messagingSenderId: "407419807208",
          projectId: "entegramam-c0d63")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Web Portal',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null ? HomeScreen() : LoginScreen(),
    );
  }
}