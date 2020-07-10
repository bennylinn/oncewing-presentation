import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/home/profile_list.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/generate_court.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:OnceWing/shared/profile_list_mini.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchHistory extends StatefulWidget {
  List<dynamic> scores;
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
                    showScore: false,
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
  List<dynamic> scores;
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
  List<dynamic> scores;
  String gameid;
  CourtHistory({Key key, this.profiles, this.gameid, this.scores})
      : super(key: key);
  List<Profile> profiles;

  @override
  _CourtHistory createState() => _CourtHistory();
}

class _CourtHistory extends State<CourtHistory> {
  List<String> uids;
  List<String> r1;
  List<String> r2;
  List<String> r3;
  List<String> r4;
  List<String> r5;
  List<String> r6;
  List<String> r7;
  List<String> r8;
  List<String> r9;
  List<String> r10;
  List<String> r11;
  List<String> r12;
  List<String> r13;
  List<String> r14;

  List<List<String>> queue;

  void initState() {
    super.initState();

    uids = widget.profiles.map((i) => i.uid).toList();
    r1 = [uids[0], uids[4], uids[6], uids[7]];
    r2 = [uids[1], uids[2], uids[3], uids[5]];
    r3 = [uids[3], uids[6], uids[5], uids[7]];
    r4 = [uids[0], uids[1], uids[2], uids[4]];
    r5 = [uids[2], uids[3], uids[4], uids[6]];
    r6 = [uids[1], uids[5], uids[0], uids[7]];
    r7 = [uids[0], uids[5], uids[3], uids[4]];
    r8 = [uids[2], uids[6], uids[1], uids[7]];
    r9 = [uids[4], uids[5], uids[1], uids[6]];
    r10 = [uids[0], uids[3], uids[2], uids[7]];
    r11 = [uids[3], uids[7], uids[1], uids[4]];
    r12 = [uids[5], uids[6], uids[0], uids[2]];
    r13 = [uids[0], uids[6], uids[1], uids[3]];
    r14 = [uids[2], uids[5], uids[4], uids[7]];

    queue = [r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14];
  }

  @override
  Widget build(BuildContext context) {
    final prfs = Provider.of<List<Profile>>(context) ?? [];

    final List<dynamic> preScores = widget.scores;

    final List<dynamic> scores = [
      preScores[(0 * 7 + 0)],
      preScores[(6 * 7 + 0)],
      preScores[(1 * 7 + 0)],
      preScores[(3 * 7 + 0)],
      preScores[(3 * 7 + 1)],
      preScores[(5 * 7 + 1)],
      preScores[(0 * 7 + 1)],
      preScores[(2 * 7 + 1)],
      preScores[(2 * 7 + 2)],
      preScores[(4 * 7 + 2)],
      preScores[(1 * 7 + 2)],
      preScores[(0 * 7 + 2)],
      preScores[(0 * 7 + 3)],
      preScores[(3 * 7 + 3)],
      preScores[(2 * 7 + 3)],
      preScores[(1 * 7 + 3)],
      preScores[(4 * 7 + 4)],
      preScores[(1 * 7 + 4)],
      preScores[(0 * 7 + 4)],
      preScores[(2 * 7 + 4)],
      preScores[(3 * 7 + 5)],
      preScores[(1 * 7 + 5)],
      preScores[(5 * 7 + 5)],
      preScores[(0 * 7 + 5)],
      preScores[(0 * 7 + 6)],
      preScores[(1 * 7 + 6)],
      preScores[(2 * 7 + 6)],
      preScores[(4 * 7 + 6)],
    ];

    Profile uidToProfile(uid) {
      Profile p =
          Profile(uid: '', name: '', clan: 'None', rank: 0, gamesPlayed: 0);
      prfs.forEach((profile) {
        if (uid == profile.uid) {
          p = profile;
        }
      });
      return p;
    } // goes through profile list to match a uid and returns that profile

    List<Profile> uidToProfiles(List<String> uids) {
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
          itemCount: queue.length,
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
                            courtProfiles: listUidToListProfiles(queue)[index],
                            index: index,
                            scores:
                                "${scores[(index * 2)]}-${scores[(index * 2 + 1)]}")
                        .horizontal(),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
