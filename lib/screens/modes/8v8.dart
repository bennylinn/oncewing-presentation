import 'dart:collection';
import 'package:OnceWing/models/game.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/shared/animated_button.dart';
import 'package:OnceWing/shared/generate_court.dart';
import 'package:OnceWing/shared/meth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:OnceWing/buttons/counterpage.dart';

class Eights extends StatefulWidget {
  // NumberOfCourts
  // NumberOfPlayers
  // NumberOfRounds

  String gameid;
  Eights(
      {Key key,
      this.profiles,
      this.viewmode,
      this.gameid,
      this.numOfCourts,
      this.numOfPlayers,
      this.numOfRounds})
      : super(key: key);
  List<Profile> profiles;
  bool viewmode;
  int numOfPlayers;
  int numOfCourts;
  int numOfRounds;

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<Eights> {
  int index;
  int numOfPlayers;
  int numOfCourts;
  int numOfRounds;

  List<dynamic> updateEights(List<dynamic> eights, int game, int score) {
    var newEights = eights.toList();
    if (game == 0) {
      game = numOfRounds; // rounds
    }
    newEights.replaceRange(game - 1, game, [score]);
    return newEights;
  }

  List<dynamic> countList;

  callback(List<int> newCount, int index) {
    // single callback function corresponding to index of count
    var newCountList = countList;
    setState(() {
      newCountList.replaceRange(index * 2, index * 2 + 1, [newCount[0]]);
    });
    setState(() {
      newCountList.replaceRange(index * 2 + 1, index * 2 + 2, [newCount[1]]);
    });
    setState(() {
      countList = newCountList;
    });
  }

  List<dynamic> uids;
  Queue queue;
  List<dynamic> inGameUids;
  Queue<List<dynamic>> queueFinished;
  List<int> order;

  List dequeueSetsOfUids(int numCourts, Queue gameQueue, bool reverse) {
    var l = [];
    if (gameQueue.length < numCourts) {
      l = List.generate(gameQueue.length, (index) => gameQueue.removeFirst());
    } else {
      l = List.generate(numCourts, (index) => gameQueue.removeFirst());
    }
    if (reverse) {
      for (var i = 0; i < l.length / 2; i++) {
        var front = l[i];
        var end = l[l.length - i - 1];
        l[i] = end;
        l[l.length - i - 1] = front;
      }
    }

    return l;
  }

  List<dynamic> checkWinners(List countlist) {
    var boolList = [];
    for (var i = 0; i < countList.length; i += 2) {
      if (countlist[i] > countlist[i + 1]) {
        boolList.add(true);
      } else {
        boolList.add(false);
      }
    }
    return boolList;
  }

  @override
  void initState() {
    super.initState();
    numOfPlayers = widget.numOfPlayers;
    numOfCourts = widget.numOfCourts;
    numOfRounds = widget.numOfRounds;

    countList = List.generate(numOfCourts * 2, (index) => 0);

    int numGames = numOfCourts * numOfRounds;

    if (!widget.viewmode) {
      for (Profile profile in widget.profiles) {
        DatabaseService(uid: profile.uid).updateUserData(
          profile.uid,
          profile.clan,
          profile.name,
          profile.rank,
          List.generate(numOfRounds,
              (index) => 0), // does not work for profile list//matchhistory
          profile.gamesPlayed,
          profile.status,
          profile.wins,
          profile.photoUrl,
          profile.exp,
          profile.fcmToken,
          profile.fireRating,
          profile.waterRating,
          profile.windRating,
          profile.earthRating,
          profile.raters,
          profile.feathers,
          profile.collection,
          profile.bio,
          profile.email,
          profile.followers,
          profile.following,
        );
      }
    }
    setState(() {
      index = 0;
    });

    uids = widget.profiles.map((i) => i.uid).toList();

    if (widget.numOfPlayers == 8) {
      order = [
        1,
        5,
        7,
        8,
        2,
        3,
        4,
        6,
        4,
        7,
        6,
        8,
        1,
        2,
        3,
        5,
        3,
        4,
        5,
        7,
        2,
        6,
        1,
        8,
        1,
        6,
        4,
        5,
        3,
        7,
        2,
        8,
        5,
        6,
        2,
        7,
        1,
        4,
        3,
        8,
        4,
        8,
        2,
        5,
        6,
        7,
        1,
        3,
        1,
        7,
        2,
        4,
        3,
        6,
        5,
        8,
      ];
    } else if (widget.numOfPlayers == 10) {
      order = [
        7,
        2,
        9,
        6,
        3,
        5,
        1,
        10,
        8,
        3,
        10,
        7,
        4,
        1,
        2,
        6,
        9,
        4,
        6,
        8,
        5,
        2,
        3,
        7,
        10,
        5,
        7,
        9,
        1,
        3,
        4,
        8,
        6,
        1,
        8,
        10,
        2,
        4,
        5,
        9,
        1,
        9,
        3,
        2,
        4,
        6,
        7,
        10,
        2,
        10,
        4,
        3,
        5,
        7,
        8,
        6,
        3,
        6,
        5,
        4,
        1,
        8,
        9,
        7,
        4,
        7,
        1,
        5,
        2,
        9,
        10,
        8,
        5,
        8,
        2,
        1,
        3,
        10,
        6,
        9,
        9,
        3,
        4,
        7,
        5,
        2,
        10,
        6,
        10,
        4,
        5,
        8,
        1,
        3,
        6,
        7,
        6,
        5,
        1,
        9,
        2,
        4,
        7,
        8,
        7,
        1,
        2,
        10,
        3,
        5,
        8,
        9,
        8,
        2,
        3,
        6,
        4,
        1,
        9,
        10
      ];
    }
    // need to subtract one for searching index

    List getGames(int numGames, List l, List gameOrder) {
      List games = [];
      //accumulate list of uids and places thetm in sets of 4
      for (var i = 0; i < numGames; i++) {
        var set = i * 4;
        var nlist = [
          l[gameOrder[set] - 1],
          l[gameOrder[set + 1] - 1],
          l[gameOrder[set + 2] - 1],
          l[gameOrder[set + 3] - 1]
        ];
        games.add(nlist);
      }

      return games;
    }

    var games = getGames(numGames, uids, order);

    queue = Queue.of(games);

    inGameUids = dequeueSetsOfUids(numOfCourts, queue, false);

    queueFinished = Queue();
  }

  bool endbutton = true;

  @override
  Widget build(BuildContext context) {
    final prfs = Provider.of<List<Profile>>(context) ?? [];

    List<List<Profile>> inGame;

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

    List<Profile> uidToProfiles(List<dynamic> uids) {
      List<Profile> list = [];
      uids.forEach((uid) {
        list.add(uidToProfile(uid));
      });
      return list;
    }

    List<List<Profile>> listUidToListProfiles(listuids) {
      return List.generate(
          queue.length, (index) => uidToProfiles(listuids.toList()[index]));
    }

    inGame = List.generate(
        inGameUids.length, (index) => uidToProfiles(inGameUids[index]));

    updateRoundRobin(Profile profile, int score, int round, double elodif) {
      var wonndered = 0;
      var exp;
      if (score >= 21) {
        wonndered = 1;
        exp = 65;
      } else {
        wonndered = 0;
        exp = 45;
      }
      DatabaseService(uid: profile.uid).updateUserData(
        profile.uid,
        profile.clan,
        profile.name,
        (profile.rank + elodif).round().toDouble(),
        updateEights(profile.eights, round + 1, score),
        profile.gamesPlayed + 1,
        profile.status,
        profile.wins + wonndered,
        profile.photoUrl,
        profile.exp + exp,
        profile.fcmToken,
        profile.fireRating,
        profile.waterRating,
        profile.windRating,
        profile.earthRating,
        profile.raters,
        profile.feathers,
        profile.collection,
        profile.bio,
        profile.email,
        profile.followers,
        profile.following,
      );
    }

    updateRRforAllCourts(List inGame, List scores, int round, List elodifs) {
      for (var i = 0; i < inGame.length; i++) {
        var temp_game = inGame[i];
        for (var j = 0; j < temp_game.length / 2; j++) {
          updateRoundRobin(
              temp_game[j * 2], scores[i * 2 + j], round, elodifs[i * 2 + j]);
          updateRoundRobin(temp_game[j * 2 + 1], scores[i * 2 + j], round,
              elodifs[i * 2 + j]);
        }
      }
    } // gotta deal with updating rounds onto scoreboard, 2nd game should update to first round

    final _controller = PageController(
      keepPage: true,
    );

    return Container(
      height: MediaQuery.of(context).size.height - 50,
      child: PageView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: PageView.builder(
                    itemCount: numOfCourts,
                    itemBuilder: (BuildContext context, int ind) {
                      return Column(
                        children: [
                          GenerateCourt(
                                  // if theres nobody on a court --> show empty court no scoreboard
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  courtProfiles: inGame[ind],
                                  countbutton: widget.viewmode
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                      child: Center(
                                                child: Text(
                                                    inGame[ind][0]
                                                        .eights[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white)),
                                              ))),
                                              Expanded(
                                                  child: Container(
                                                      child: Center(
                                                child: Text(
                                                    inGame[ind][2]
                                                        .eights[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white)),
                                              ))),
                                            ],
                                          ),
                                        )
                                      : CountButton(
                                          [
                                            countList[ind * 2],
                                            countList[ind * 2 + 1]
                                          ],
                                          callback,
                                          ind,
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                        ))
                              .vertical(),
                          Container(
                            height: 20,
                            child: Text(
                              'Court ${ind + 1}',
                              style: TextStyle(
                                  color: Colors.blue[100],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Center(
                  child: Text(
                      'Round ${(index < numOfRounds) ? index + 1 : 'Finished'}',
                      style: TextStyle(fontSize: 20, color: Color(0xffC49859))),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                              elevation: 0,
                              onPressed: () {
                                if (index > 0) {
                                  if (index != numOfRounds) {
                                    inGameUids.forEach((element) {
                                      queue.addFirst(element);
                                    });

                                    var next = dequeueSetsOfUids(
                                        numOfCourts, queueFinished, true);

                                    inGameUids = next;
                                  }
                                  setState(() {
                                    index--;
                                  });
                                }
                              },
                              color: Colors.transparent,
                              child: Text(
                                'Previous Match',
                                style: TextStyle(
                                    color: Colors.blue[100], fontSize: 20),
                              )),
                        ),
                      ),
                      Container(
                        // decoration: BoxDecoration(
                        //   border: Border(
                        //     left: BorderSide(
                        //       color: Colors.black,
                        //       width: 3.0,
                        //     ),
                        //   )
                        // ),
                        child: SizedBox(
                          height: 50,
                          child: (index == numOfRounds)
                              ? AnimatedButton(
                                  onPressed: (_) {
                                    var temp_prfs = widget.profiles;
                                    temp_prfs.sort(
                                        (a, b) => a.name.compareTo(b.name));
                                    var alphauid =
                                        temp_prfs.map((i) => i.uid).toList();

                                    var game = Provider.of<GameData>(context);

                                    GameDatabaseService().updateGameData(
                                        widget.gameid,
                                        alphauid,
                                        game.type,
                                        game.groupId,
                                        numOfRounds,
                                        [
                                          ...uidToProfile(alphauid[0]).eights,
                                          ...uidToProfile(alphauid[1]).eights,
                                          ...uidToProfile(alphauid[2]).eights,
                                          ...uidToProfile(alphauid[3]).eights,
                                          ...uidToProfile(alphauid[4]).eights,
                                          ...uidToProfile(alphauid[5]).eights,
                                          ...uidToProfile(alphauid[6]).eights,
                                          ...uidToProfile(alphauid[7]).eights,
                                        ],
                                        DateTime.now(),
                                        false);

                                    setState(() {
                                      endbutton = false;
                                    });
                                  },
                                  text: 'End',
                                  ready: endbutton,
                                )
                              : RaisedButton.icon(
                                  icon: Icon(Icons.arrow_right,
                                      color: Color(0xffC49859)),
                                  elevation: 4,
                                  onPressed: () {
                                    if (index < numOfRounds - 1) {
                                      setState(() {
                                        index++;
                                      });

                                      inGameUids.forEach((element) {
                                        queueFinished.addFirst(element);
                                      });

                                      var next = dequeueSetsOfUids(
                                          numOfCourts, queue, false);

                                      inGameUids = next;
                                    }
                                  },
                                  onLongPress: () {
                                    if (index < numOfRounds) {
                                      var boolList = checkWinners(countList);
                                      print(boolList);
                                      print(countList);
                                      // accumulate which side wins and counts into arrays

                                      var eloDifs =
                                          eloDifList(inGame, boolList);

                                      if (!widget.viewmode) {
                                        updateRRforAllCourts(
                                            inGame, countList, index, eloDifs);
                                      } // write a function that updates round onto database,
                                      // for each side
                                      if (index < numOfRounds - 1) {
                                        inGameUids.forEach((element) {
                                          queueFinished.addFirst(element);
                                        });

                                        var next = dequeueSetsOfUids(
                                            numOfCourts, queue, false);

                                        inGameUids = next;
                                      }

                                      setState(() {
                                        index++;
                                      });
                                    }
                                  },
                                  label: Text(
                                    'Next Match',
                                    style: TextStyle(
                                        color: Color(0xffC49859),
                                        fontSize: 20), // fix if statement box
                                  ),
                                  color: Colors.red.withOpacity(0.5),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Scaffold(
            appBar: AppBar(
              actions: [
                FlatButton(
                  child: Icon(
                    Icons.arrow_drop_up,
                    color: Colors.blue[100],
                    size: 40,
                  ),
                  onPressed: () {
                    _controller.animateTo(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease);
                  },
                )
              ],
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Upcoming Games',
                style: TextStyle(color: Colors.blue[100], fontSize: 20),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              height: 700,
              width: 400,
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: queue.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: 250,
                      width: 400,
                      child: GenerateCourt(
                              courtProfiles:
                                  listUidToListProfiles(queue)[index],
                              index: index,
                              scores: '')
                          .horizontal());
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
