import 'package:OnceWing/models/game.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/modes/game_home.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoLiveGame extends StatefulWidget {
  final String gameid;
  const GoLiveGame({this.gameid});
  @override
  _GoLiveGameState createState() => _GoLiveGameState();
}

class _GoLiveGameState extends State<GoLiveGame> {
  @override
  Widget build(BuildContext context) {
    var _profiles = Provider.of<List<Profile>>(context);

    List<Profile> uidToProfiles(uids) {
      return _profiles
          .where((item) => uids.contains(item.uid))
          .toList(); // sort highest date first
    }

    return StreamBuilder(
        stream: GameDatabaseService(gameid: widget.gameid).gameData,
        builder: (context, snapshot) {
          GameData game = snapshot.data;
          return EightsPage(
            profiles: uidToProfiles(game.uids),
            viewmode: true,
            numOfCourts: game.numOfCourts,
            numOfPlayers: game.uids.length,
            numOfRounds: game.round,
            gameid: game.gameid,
            queueMap: game.upcomingGames,
            queueFinishedMap: game.finishedGames,
            inGameUidsMap: game.inGame,
            init: false,
          );
        });
  }
}
