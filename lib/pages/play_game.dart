import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/results_room.dart';

class PlayGame extends StatefulWidget {

  final String playerName;
  final String gameName;

  const PlayGame({Key? key, required this.gameName, required this.playerName,}) : super(key: key);

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  //bool hasPlayed = false;
  
  int rolledNumber = 0;

  rollDice(){
    setState(() {
      rolledNumber = Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(child: Text(rolledNumber.toString(), style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),)
            ],
          ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                  onPressed: () async{

                      rollDice();

                      await FirebaseFirestore.instance.collection("games")
                          .doc(widget.gameName)
                          .collection(widget.gameName)
                          .doc(widget.playerName)
                          .update(
                          {
                            "score": rolledNumber,
                            "finishedPlaying": true,
                          });

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ResultsPage(
                          gameName: widget.gameName,
                          playerName: widget.playerName,
                          rolledNumber: rolledNumber,
                        );
                      }));
                  },
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Text("Roll Dice"),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

