import 'package:OnceWing/models/game.dart';
import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/modes/game_home.dart';
import 'package:OnceWing/screens/modes/match_history.dart';
import 'package:OnceWing/shared/profile_list_mini.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMatchHistory extends StatefulWidget {
  GroupData group;
  GroupMatchHistory({this.group});
  @override
  _GroupMatchHistoryState createState() => _GroupMatchHistoryState();
}

class _GroupMatchHistoryState extends State<GroupMatchHistory> {
  @override
  Widget build(BuildContext context) {
    var allGames = Provider.of<List<GameData>>(context);
    List<GameData> games = allGames
        .where((game) => (game.groupId == widget.group.groupId))
        .toList();

    games.sort((a, b) => b.date.compareTo(a.date));

    var _profiles = Provider.of<List<Profile>>(context);

    List<Profile> uidToProfiles(uids) {
      return _profiles
          .where((item) => uids.contains(item.uid))
          .toList(); // sort highest date first
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Center(
                child: Text('Recent Match History',
                    style: TextStyle(color: Colors.red, fontSize: 20))),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                  color: Colors.blue[100], width: 3)),
                          elevation: 0.0,
                          color: Colors.transparent,
                          borderOnForeground: true,
                          child: Container(
                              child: ExpansionTile(
                                  trailing: FlatButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    games[index].live
                                                        ? EightsPage(
                                                            profiles:
                                                                uidToProfiles(
                                                                    games[index]
                                                                        .uids),
                                                            viewmode: true,
                                                            numOfCourts: games[
                                                                    index]
                                                                .numOfCourts,
                                                            numOfPlayers:
                                                                games[index]
                                                                    .uids
                                                                    .length,
                                                            numOfRounds:
                                                                games[index]
                                                                    .round,
                                                            gameid: games[index]
                                                                .gameid,
                                                            queueMap: games[
                                                                    index]
                                                                .upcomingGames,
                                                            queueFinishedMap:
                                                                games[index]
                                                                    .finishedGames,
                                                            inGameUidsMap:
                                                                games[index]
                                                                    .inGame,
                                                            init: false,
                                                          )
                                                        : MatchHistory(
                                                            gameid: games[index]
                                                                .gameid,
                                                            profiles:
                                                                uidToProfiles(
                                                                    games[index]
                                                                        .uids),
                                                            scores: games[index]
                                                                .scores)));
                                      },
                                      icon: Icon(Icons.remove_red_eye,
                                          color: !games[index].live
                                              ? Colors.blue[100]
                                              : Colors.red[300]),
                                      label: Text(
                                        !games[index].live ? 'View' : 'Live',
                                        style: TextStyle(
                                            color: !games[index].live
                                                ? Colors.blue[100]
                                                : Colors.red[300]),
                                      )),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('assets/swordshield.png'),
                                  ),
                                  title: Text(
                                    '${games[index].date.year}-${games[index].date.month}-${games[index].date.day}',
                                    style: TextStyle(color: Colors.blue[100]),
                                  ),
                                  children: <Widget>[
                                Container(
                                  width: 500,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  height: 250,
                                  child: MiniProfileList(
                                    showScore: true,
                                    profiles: uidToProfiles(games[index].uids),
                                    scores: games[index].scores,
                                  ),
                                ),
                              ])),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
