import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/modes/8v8.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/services/database.dart';
import 'package:provider/provider.dart';
import 'package:OnceWing/screens/home/profile_list.dart';

class Courts extends StatefulWidget {
  String gameid;
  List<Profile> profiles;
  bool viewmode;
  int numOfPlayers;
  int numOfCourts;
  int numOfRounds;
  Courts(
      {Key key,
      this.profiles,
      this.viewmode,
      this.gameid,
      this.numOfCourts,
      this.numOfPlayers,
      this.numOfRounds})
      : super(key: key);

  @override
  _Courts createState() => new _Courts();
}

class _Courts extends State<Courts> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Profile>>.value(
        value: DatabaseService().profiles,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.7, 1],
                  colors: [Color(0xff021420), Color(0xff00484F)])),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: Column(children: [
                  Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: (widget.profiles == null)
                            ? Loading()
                            : StreamProvider.value(
                                value:
                                    GameDatabaseService(gameid: widget.gameid)
                                        .gameData,
                                child: Eights(
                                  profiles: widget.profiles,
                                  viewmode: widget.viewmode,
                                  gameid: widget.gameid,
                                  numOfCourts: widget.numOfCourts,
                                  numOfPlayers: widget.numOfPlayers,
                                  numOfRounds: widget.numOfRounds,
                                ),
                              ),
                      )),
                  Container(
                    height: 50,
                    color: Colors.transparent,
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}
