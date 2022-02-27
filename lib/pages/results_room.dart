import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ResultsPage extends StatefulWidget {

  final String playerName;
  final String gameName;
  final int rolledNumber;

  const ResultsPage({Key? key, required this.gameName, required this.playerName, required this.rolledNumber,}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  bool reRendered =  false;

  int usersInRoom = 1;

  bool displayWinner = false;

  List  playerNameList = [];
  List  playerScoreList = [];
  List  playerStatusList = [];

  String winnerName = "";
  int winnerScore = 0;
  late int winnerIndex;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child:displayWinner? Card(
                        child: ListTile(
                          title: Text("Winner: $winnerName"),
                          subtitle: Text("Score: $winnerScore"),
                        ),
                      ): const Text("Somebody's still playing"),
                    ),
                  )
              ),
              Expanded(
                flex: 4,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("games")
                        .doc(widget.gameName)
                        .collection(widget.gameName)
                        .snapshots(),

                    builder: (context,AsyncSnapshot snapshot){
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      final players = snapshot.data.docs;


                      for(var player in players){
                        final playerName = player["name"];
                        final score = player["score"];
                        final finishedPlaying = player["finishedPlaying"];

                        if(score>winnerScore){
                          winnerScore = score;
                        }

                        playerNameList.add(playerName);
                        playerScoreList.add(score);
                        playerStatusList.add(finishedPlaying);
                      }

                      usersInRoom = players.length;

                      if(playerStatusList.contains(false)){
                        displayWinner = false;
                      } else {
                        winnerIndex = playerScoreList.indexOf(winnerScore);

                        winnerName = playerNameList[winnerIndex];

                        displayWinner = true;
                      }


                       return ListView.builder(
                         itemCount: players.length,
                           itemBuilder: (context, index){

                             SchedulerBinding.instance!.addPostFrameCallback((_) {
                               reRendered? null : setState(() {
                                 reRendered = true;
                               });
                             });

                             return Card(
                               child: ListTile(
                                 title: Text("Name: ${playerNameList[index]}"),
                                 subtitle: Text("Score: ${playerScoreList[index].toString()}"),
                                 trailing: playerStatusList[index]? const Text("Finished game"): const Text("Still playing"),
                               ),
                             );
                           }
                       );
                    },
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}