
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/games_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String userName = "";

    final _fireStore = FirebaseFirestore.instance;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value){
                userName = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your username',
              ),
            ),
            const SizedBox(height: 40,),
            ElevatedButton(
                onPressed: () async{

                  await _fireStore.collection("users").doc(userName).set({
                    "game": userName,
                    "isPlaying": false,
                    "score": 1,
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GamesList(userName: userName);
                  }),);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Text("Start Game"),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
