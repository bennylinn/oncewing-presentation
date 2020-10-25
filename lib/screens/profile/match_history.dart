import 'package:OnceWing/models/game.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/modes/game_home.dart';
import 'package:OnceWing/screens/modes/match_history.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/components/profile_widgets/profile_list_mini.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows entire match history of current profile in a ListView
/// Each ListView item is a Card containing a dated event

class PlayerMatchHistory extends StatefulWidget {
  final String uid;
  PlayerMatchHistory({this.uid});

  @override
  _PlayerMatchHistoryState createState() => _PlayerMatchHistoryState();
}

class _PlayerMatchHistoryState extends State<PlayerMatchHistory> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Profile>>.value(value: DatabaseService().profiles),
        StreamProvider<List<GameData>>.value(
            value: GameDatabaseService().gameDatas)
      ],
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Match History',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(height: 15),
            PlayerEvents(uid: widget.uid),
          ],
        ),
      ),
    );
  }
}

class PlayerEvents extends StatefulWidget {
  final String uid;
  PlayerEvents({this.uid});
  @override
  _PlayerEventsState createState() => _PlayerEventsState();
}

class _PlayerEventsState extends State<PlayerEvents> {
  @override
  Widget build(BuildContext context) {
    var allGames = Provider.of<List<GameData>>(context);
    var _profiles = Provider.of<List<Profile>>(context);

    List<GameData> games = [];

    allGames.forEach((game) {
      if (game.uids.contains(widget.uid)) {
        games.add(game);
      }
    });

    games.sort((a, b) => b.date.compareTo(a.date));

    List<Profile> uidToProfiles(uids) {
      return _profiles
          .where((item) => uids.contains(item.uid))
          .toList(); // sort highest date first
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView.builder(
          primary: false,
          itemCount: games.length,
          itemBuilder: (context, index) {
            return Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.blue[100], width: 0.1)),
                elevation: 0.0,
                color: Colors.black.withOpacity(0.4),
                borderOnForeground: true,
                child: Container(
                    child: ExpansionTile(
                        trailing: Container(
                          width: 117,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              VerticalDivider(
                                color: Colors.grey,
                                indent: 10,
                                endIndent: 10,
                              ),
                              FlatButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                games[index].live
                                                    ? EightsPage(
                                                        profiles: uidToProfiles(
                                                            games[index].uids),
                                                        viewmode: true,
                                                        numOfCourts:
                                                            games[index]
                                                                .numOfCourts,
                                                        numOfPlayers:
                                                            games[index]
                                                                .uids
                                                                .length,
                                                        numOfRounds:
                                                            games[index].round,
                                                        gameid:
                                                            games[index].gameid,
                                                        queueMap: games[index]
                                                            .upcomingGames,
                                                        queueFinishedMap:
                                                            games[index]
                                                                .finishedGames,
                                                        inGameUidsMap:
                                                            games[index].inGame,
                                                        init: false,
                                                      )
                                                    : MatchHistory(
                                                        gameid:
                                                            games[index].gameid,
                                                        profiles: uidToProfiles(
                                                            games[index].uids),
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
                            ],
                          ),
                        ),
                        leading: Container(
                          padding: EdgeInsets.only(top: 8),
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    color: Colors.transparent,
                                    height: 15,
                                    width: 15,
                                    child: Image(
                                        image: AssetImage(
                                            'assets/swordshield.png')),
                                  ),
                                  Text(
                                      ' ${games[index].type}: ${games[index].date.year}-${games[index].date.month}-${games[index].date.day}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${games[index].uids.length}P Round Robin Doubles',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                        title: Container(),
                        children: <Widget>[
                      Container(
                        width: 500,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 250,
                        child: MiniProfileList(
                          showScore: games[index].live,
                          profiles: uidToProfiles(games[index].uids),
                          scores: games[index].scores,
                        ), // live property not working index issue
                      ),
                    ])),
              ),
            );
          }),
    );
  }
}
