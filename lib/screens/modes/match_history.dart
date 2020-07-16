import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/home/profile_list.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/game_order.dart';
import 'package:OnceWing/shared/generate_court.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:OnceWing/shared/profile_list_mini.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchHistory extends StatefulWidget {
  Map scores;
  List<Profile> profiles;
  String gameid;
  MatchHistory({Key key, this.profiles, this.gameid, this.scores})
      : super(key: key);

  @override
  _MatchHistory createState() => new _MatchHistory();
}

class _MatchHistory extends State<MatchHistory> {
  @override
  Widget build(BuildContext context) {
    var _profiles = widget.profiles;
    _profiles.sort((a, b) => a.name.compareTo(b.name));

    void _showPlayerPanel() {
      // scores need to be updated for history
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamProvider<List<Profile>>.value(
            value: DatabaseService().profiles,
            child: Container(
              color: Color(0xFF737373),
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: AppBar(
                  backgroundColor: Color(0xff050E14),
                  centerTitle: true,
                  title: Text('Players',
                      style: TextStyle(color: Colors.blue[100])),
                  elevation: 0,
                ),
                body: Container(
                  padding: EdgeInsets.all(0),
                  color: Color(0xffC49859),
                  child: MiniProfileList(
                    showScore: true,
                    profiles: _profiles,
                    scores: widget.scores,
                  ), // probably put the mini here
                ),
              ),
            ),
          );
        },
        enableDrag: true,
        isScrollControlled: false,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton.icon(
                  color: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_drop_up,
                    color: Colors.blue[100],
                  ),
                  elevation: 0,
                  onPressed: () => _showPlayerPanel(),
                  label: Text(
                    'Scoreboard',
                    style: TextStyle(fontSize: 15, color: Colors.blue[100]),
                  )),
            ),
          ],
          backgroundColor: Color(0xff021420),
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Match History',
            style: TextStyle(color: Color(0xffC49859), fontSize: 18),
          )),
      body: MatchHistoryWrapper(
          profiles: _profiles, gameid: widget.gameid, scores: widget.scores),
    );
  }
}

class MatchHistoryWrapper extends StatefulWidget {
  Map scores;
  String gameid;
  List<Profile> profiles;
  MatchHistoryWrapper({Key key, this.profiles, this.gameid, this.scores})
      : super(key: key);

  @override
  _MatchHistoryWrapper createState() => new _MatchHistoryWrapper();
}

class _MatchHistoryWrapper extends State<MatchHistoryWrapper> {
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
                            : CourtHistory(
                                profiles: widget.profiles,
                                gameid: widget.gameid,
                                scores: widget.scores),
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

class CourtHistory extends StatefulWidget {
  Map scores;
  String gameid;
  CourtHistory({Key key, this.profiles, this.gameid, this.scores})
      : super(key: key);
  List<Profile> profiles;

  @override
  _CourtHistory createState() => _CourtHistory();
}

class _CourtHistory extends State<CourtHistory> {
  int rounds;
  int numPlayers;

  List<dynamic> uids;
  List<dynamic> queue;

  void initState() {
    super.initState();
    numPlayers = widget.profiles.length;
    rounds = (widget.scores.length / numPlayers).round();

    uids = widget.profiles.map((i) => i.uid).toList();
  }

  @override
  Widget build(BuildContext context) {
    final prfs = Provider.of<List<Profile>>(context) ?? [];

    final Map preScores = widget.scores;

    Profile uidToProfile(String uid) {
      Profile p =
          Profile(uid: '', name: '', clan: 'None', rank: 0, gamesPlayed: 0);
      prfs.forEach((profile) {
        if (uid == profile.uid) {
          p = profile;
        }
      });
      return p;
    } // goes through profile list to match a uid and returns that profile

    List<Profile> uidToProfiles(List<dynamic> uids) {
      List<Profile> list = [];
      uids.forEach((uid) {
        list.add(uidToProfile(uid));
      });
      return list;
    } // converts list of uids to profiles

    List<List<Profile>> listUidToListProfiles(listuids) {
      return List.generate(
          queue.length, (index) => uidToProfiles(listuids.toList()[index]));
    }

    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Container(
        height: MediaQuery.of(context).size.height - 100,
        width: 400,
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: preScores.length,
          itemBuilder: (context, index) {
            return Container(
                height: 250,
                width: 400,
                child: Column(
                  children: [
                    Center(
                      child: Text('Game ${index + 1}',
                          style: TextStyle(color: Colors.blue, fontSize: 18)),
                    ),
                    GenerateCourt(
                            courtProfiles: uidToProfiles(
                                preScores[index.toString()]['uids']),
                            index: index,
                            scores:
                                "${preScores[index.toString()]['scores'][0]}-${preScores[index.toString()]['scores'][1]}")
                        .horizontal(context),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
