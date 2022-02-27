import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/waiting_room.dart';

class GamesList extends StatefulWidget {

  final String userName;
   const GamesList({Key? key, required this.userName}) : super(key: key);

  @override
  _GamesListState createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {

  String gameName = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.userName}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextField(
                          onChanged: (value){
                            gameName = value;
                          },
                          decoration: const InputDecoration(
                            constraints: BoxConstraints(
                              maxWidth: 160
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Name your game',
                          ),
                        ),
                        const SizedBox(width: 15,),
                        ElevatedButton(
                          onPressed: () async{
                            FirebaseFirestore.instance.collection("games").doc(gameName).set({"hasStarted": false});
                            FirebaseFirestore.instance.collection("games").doc(gameName).collection(gameName).doc(widget.userName).set({
                              "name": widget.userName,
                              "score": 0,
                              "finishedPlaying": false,
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return WaitingRoom(
                                roomName: gameName,
                                userName: widget.userName,
                              );
                            }));
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text("Create Game"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    const Divider(color: Colors.grey,),
                    const SizedBox(height: 30,),

                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("games").limit(10).snapshots(),
                    builder: (context,AsyncSnapshot snapshot){
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(),);
                      }

                      final games = snapshot.data.docs;

                      List<GameData> gameNamesList = [];

                      for (var game in games) {
                        final gameName = game.id;
                        var hasStarted = game["hasStarted"];

                        if(hasStarted == false){
                          gameNamesList.add(GameData(gameName: gameName, hasStarted: hasStarted));
                        }
                      }

                      return ListView.builder(
                        itemCount: gameNamesList.length,
                          itemBuilder: (context, int index){
                            return Card(
                              child: ListTile(
                                title: Text(gameNamesList[index].gameName),
                                trailing: gameNamesList[index].hasStarted?
                                const Text("Ongoing"):
                                  ElevatedButton(
                                  child: const Text("Join"),
                                  onPressed: (){
                                    FirebaseFirestore.instance.collection("games")
                                        .doc(gameNamesList[index].gameName)
                                        .collection(gameNamesList[index].gameName)
                                        .doc(widget.userName).set({
                                      "name": widget.userName,
                                      "score": 0,
                                      "finishedPlaying": false,
                                    });

                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return WaitingRoom(
                                        roomName: gameNamesList[index].gameName,
                                        userName: widget.userName,
                                      );
                                    }));
                                  },
                                ),
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

class GameData {
  String gameName;
  bool hasStarted;
  GameData({required this.gameName, required this.hasStarted});
}