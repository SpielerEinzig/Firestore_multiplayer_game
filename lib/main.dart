import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAzGebJZ6B1SCZKONuRmBeIeNOTv0IwGiQ",
          authDomain: "coin-toss-aa268.firebaseapp.com",
          databaseURL: "https://coin-toss-aa268-default-rtdb.firebaseio.com",
          projectId: "coin-toss-aa268",
          storageBucket: "coin-toss-aa268.appspot.com",
          messagingSenderId: "395079329419",
          appId: "1:395079329419:web:0667a6b47679d3bd70168e",
      )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.dark(),
    );
  }
}

