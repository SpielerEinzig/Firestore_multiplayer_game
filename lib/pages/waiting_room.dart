import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/pages/play_game.dart';


int usersInRoom = 1;

class WaitingRoom extends StatefulWidget {

  final String roomName;
  final String userName;

  const WaitingRoom({Key? key, required this.roomName, required this.userName}) : super(key: key);

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> with WidgetsBindingObserver{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
   didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isBackground = state == AppLifecycleState.paused;

    if(isBackground){
      FirebaseFirestore.instance.collection("games").doc(widget.roomName).collection(widget.roomName).doc(widget.userName).delete();
      print(isBackground);
      print(state);
      print("app killed");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Number of users in room: $usersInRoom"),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.refresh)
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("games").doc(widget.roomName).collection(widget.roomName).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }


                      final players = snapshot.data.docs;

                      usersInRoom = players.length;

                      List playerNames = [];

                      for(var player in players){
                        final playerName = player.id;

                        playerNames.add(playerName);
                      }

                      return ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index){
                          if(usersInRoom >= 2){
                            SchedulerBinding.instance!.addPostFrameCallback((_) {

                              // add your code here.
                              FirebaseFirestore.instance.collection("games").doc(widget.roomName).update(
                                  {
                                    "hasStarted": true
                                  });

                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  PlayGame(gameName: widget.roomName, playerName: widget.userName)));

                            });

                          }
                          return Card(
                            child: ListTile(
                              title: Text(playerNames[index]),
                            ),
                          );
                        },
                      );
                    }
                ),
              )
            ],
          ),
      ),
    );
  }
}
