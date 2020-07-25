import 'dart:collection';
import 'package:OnceWing/buttons/toggle.dart';
import 'package:OnceWing/models/game.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/shared/alert.dart';
import 'package:OnceWing/shared/animated_button.dart';
import 'package:OnceWing/shared/game_order.dart';
import 'package:OnceWing/shared/generate_court.dart';
import 'package:OnceWing/shared/meth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      this.numOfRounds,
      this.queueMap,
      this.queueFinishedMap,
      this.inGameUidsMap,
      this.init})
      : super(key: key);
  List<Profile> profiles;
  bool viewmode;
  int numOfPlayers;
  int numOfCourts;
  int numOfRounds;
  Map queueMap;
  Map queueFinishedMap;
  Map inGameUidsMap;
  bool init;

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<Eights> {
  int index;
  int numOfPlayers;
  int numOfCourts;
  int numOfRounds;
  Map allGames = {};
  bool finished = false;
  bool weReadyToUpdate = false;

  toggleCallback(lebool) {
    setState(() {
      weReadyToUpdate = lebool;
    });
  }

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
  Queue queueFinished;
  List<int> order;
  List<List> courtHistory;
  bool viewUpcomingToggle = true;

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

  bool checkWinner(int court, List countlist) {
    if (countlist[0] > countlist[1]) {
      return true;
    } else {
      return false;
    }
  }

  List scoresCourt(int court, List countlist) {
    List scores = [];
    for (var i = 2 * court; i < 2 * court + 2; i++) {
      scores.add(countlist[i]);
    }
    return scores;
  }

  void clearScoresOnCourt(int court) {
    for (var i = 2 * court; i < 2 * court + 2; i++) {
      countList[i] = 0;
    }
  }

  final _controller = PageController(
    keepPage: true,
  );

  final _courtController = PageController(initialPage: 0, keepPage: true);

  int _currentCourtValue = 0;

  bool inHere(int currentCourtValue, List inGameUids, User user) {
    return inGameUids[currentCourtValue].contains(user.uid);
  }

  Map getMapFromList(List l) {
    // list of lists
    // keys are string values
    var newDict = {};
    for (var i = 0; i < l.length; i++) {
      newDict[i.toString()] = l[i];
    }

    return newDict;
  }

  @override
  void initState() {
    super.initState();
    numOfPlayers = widget.numOfPlayers;
    numOfCourts = widget.numOfCourts;
    numOfRounds = widget.numOfRounds;

    countList = List.generate(numOfCourts * 2, (index) => 0);
    courtHistory = List.generate(numOfCourts, (index) => []);

    int numGames = numOfCourts * numOfRounds;

    if (!widget.viewmode) {
      for (Profile profile in widget.profiles) {
        DatabaseService(uid: profile.uid).updateUserData(
          profile.uid,
          profile.clan,
          profile.name,
          profile.rank,
          List.generate(numOfRounds, (index) => 0),
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

    order = GameOrder().gameOrder(widget.numOfPlayers, widget.numOfRounds);

    List getGames(int numGames, List l, List gameOrder) {
      List games = [];
      //accumulate list of uids and places thetm in sets of 4
      for (var i = 0; i < numGames; i++) {
        var st = i * 4;
        var nlist = [
          l[gameOrder[st] - 1],
          l[gameOrder[st + 1] - 1],
          l[gameOrder[st + 2] - 1],
          l[gameOrder[st + 3] - 1]
        ];
        games.add(nlist);
      }
      return games;
    }

    var games = getGames(numGames, uids, order);

    // for (var i = 0; i < games.length; i++) {
    //   allGames[i] = {
    //     'uids': games[i],
    //     'scores': [0, 0],
    //     'court': -1
    //   };
    // } // populating all games into map
    if (widget.init) {
      queue = Queue.of(games);

      inGameUids = dequeueSetsOfUids(numOfCourts, queue, false);

      queueFinished = Queue();

      Firestore.instance
          .collection('games')
          .document(widget.gameid)
          .updateData({
        'upcomingGames': getMapFromList(queue.toList()),
        'finishedGames': getMapFromList(queueFinished.toList()),
        'inGame': getMapFromList(inGameUids),
      });

      widget.profiles.forEach((profile) {
        Firestore.instance
            .collection('profiles')
            .document(profile.uid)
            .updateData({'status': widget.gameid});
      });
    } else {}
  }

  bool endbutton = true;

  void pageChanged(int index) {
    setState(() {
      _currentCourtValue = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    GameData deGaem = Provider.of<GameData>(context);
    print(deGaem.gameid);
    var qList = [];
    var qfList = [];
    var igList = [];
    var aG = {};

    SplayTreeMap<String, dynamic>.from(deGaem.upcomingGames,
        (a, b) => int.parse(a).compareTo(int.parse(b))).forEach((key, value) {
      qList.add(value);
    });

    SplayTreeMap<String, dynamic>.from(deGaem.finishedGames,
        (a, b) => int.parse(a).compareTo(int.parse(b))).forEach((key, value) {
      qfList.add(value);
    });
    SplayTreeMap<String, dynamic>.from(
            deGaem.inGame, (a, b) => int.parse(a).compareTo(int.parse(b)))
        .forEach((key, value) {
      igList.add(value);
    });
    SplayTreeMap<String, dynamic>.from(
            deGaem.scores, (a, b) => int.parse(a).compareTo(int.parse(b)))
        .forEach((key, value) {
      aG[int.parse(key)] = value;
    });
    setState(() {
      queue = Queue.of(qList);
    });
    setState(() {
      inGameUids = igList;
    });
    setState(() {
      queueFinished = Queue.of(qfList);
    });
    setState(() {
      allGames = aG;
    });
    index = (queueFinished.length / widget.numOfCourts).truncate();

    if (countList[_currentCourtValue * 2] >= 21 ||
        countList[_currentCourtValue * 2 + 1] >= 21) {
      setState(() {
        weReadyToUpdate = true;
      });
    } else {
      setState(() {
        weReadyToUpdate = false;
      });
    }

    final user = Provider.of<User>(context);

    List<List<Profile>> inGame;

    bool ih = inHere(_currentCourtValue, inGameUids, user);
    var prfs = Provider.of<List<Profile>>(context) ?? [];

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

    Future<void> updateRoundRobinProfile(
        Profile profile, int score, int round, int elodif) {
      var wonndered = 0;
      var exp;
      if (score >= 21) {
        wonndered = 1;
        exp = 65;
      } else {
        wonndered = 0;
        exp = 45;
      }
      // await DatabaseService(uid: profile.uid).updateUserData(
      //   profile.uid,
      //   profile.clan,
      //   profile.name,
      //   (profile.rank + elodif).round(),
      //   updateEights(profile.eights, round + 1, score),
      //   profile.gamesPlayed + 1,
      //   profile.status,
      //   profile.wins + wonndered,
      //   profile.photoUrl,
      //   profile.exp + exp,
      //   profile.fcmToken,
      //   profile.fireRating,
      //   profile.waterRating,
      //   profile.windRating,
      //   profile.earthRating,
      //   profile.raters,
      //   profile.feathers,
      //   profile.collection,
      //   profile.bio,
      //   profile.email,
      //   profile.followers,
      //   profile.following,
      // );
    }

    updateEightsProfile(Profile profile, int score, int round) {
      DatabaseService(uid: profile.uid).updateUserData(
        profile.uid,
        profile.clan,
        profile.name,
        profile.rank,
        updateEights(profile.eights, round + 1, score),
        profile.gamesPlayed + 1,
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

    updateRREights(List game, List scores, round) {
      if (game.length == 4) {
        updateEightsProfile(game[0], scores[0], round);
        updateEightsProfile(game[1], scores[0], round);
        updateEightsProfile(game[2], scores[1], round);
        updateEightsProfile(game[3], scores[1], round);
      }
    }

    // Future<void> updateRRcourt(List game, List scores, elodif) async {
    //   if (game.length == 4) {
    //     await updateRoundRobinProfile(game[0], scores[0], elodif[0]);
    //     await updateRoundRobinProfile(game[1], scores[0], elodif[0]);
    //     await updateRoundRobinProfile(game[2], scores[1], elodif[1]);
    //     await updateRoundRobinProfile(game[3], scores[1], elodif[1]);
    //     setState(() {});
    //   }
    // }

    Future<void> updateAllGames(Map allGames) async {
      Map yuhMap = {}; // map to keep track of calculations
      widget.profiles.forEach((profile) {
        yuhMap[profile.uid] = {
          'name': profile.name,
          'rank': profile.rank,
          'gamesPlayed': profile.gamesPlayed,
          'wins': profile.wins,
        };
      });

      SplayTreeMap.from(allGames, (a, b) => a.compareTo(b))
          .forEach((key, value) async {
        List uids = allGames[key]['uids'];

        bool side1wins =
            allGames[key]['scores'][0] > allGames[key]['scores'][1];

        var listRank = [];
        uids.forEach((uid) {
          listRank.add(yuhMap[uid]['rank']);
        });

        List eloDif = eloDifSingleNumsOnly(listRank, side1wins);
        print(eloDif);

        for (var i = 0; i < 4; i++) {
          yuhMap[uids[i]]['rank'] += (i <= 1) ? eloDif[0] : eloDif[1];
          yuhMap[uids[i]]['gamesPlayed']++;
          yuhMap[uids[i]]['wins'] +=
              ((side1wins && i <= 1) || (!side1wins && i > 1)) ? 1 : 0;
        }
      });
      print(yuhMap);

      yuhMap.forEach((uid, data) async {
        await Firestore.instance
            .collection('profiles')
            .document(uid)
            .updateData({
          'rank': yuhMap[uid]['rank'],
          'gamesPlayed': yuhMap[uid]['gamesPlayed'],
          'wins': yuhMap[uid]['wins'],
        }).then((value) => print('done ${yuhMap[uid]['name']}'));
      });
    }

    updateRRforAllCourts(List inGame, List scores, int round, List elodifs) {
      for (var i = 0; i < inGame.length; i++) {
        var temp_game = inGame[i];
        for (var j = 0; j < temp_game.length / 2; j++) {
          updateRoundRobinProfile(
              temp_game[j * 2], scores[i * 2 + j], round, elodifs[i * 2 + j]);
          updateRoundRobinProfile(temp_game[j * 2 + 1], scores[i * 2 + j],
              round, elodifs[i * 2 + j]);
        }
      }
    } // gotta deal with updating rounds onto scoreboard, 2nd game should update to first round

    void updateMapGames(
        Map allGames, List scores, int index, int whichCourt, List uids) {
      // var _currentGame = allGames[index];
      var newGame = {'uids': uids, 'scores': scores, 'court': whichCourt};
      allGames[index] = newGame;
    }

    return Container(
      height: MediaQuery.of(context).size.height - 50,
      child: finished // -->
          ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: allGames.length,
              itemBuilder: (context, ind) {
                var temp_scores = allGames[ind]['scores'];
                return Container(
                    height: 250,
                    width: 400,
                    child: GenerateCourt(
                            courtProfiles: List.generate(
                                4,
                                (index) =>
                                    uidToProfile(allGames[ind]['uids'][index])),
                            index: index,
                            scores: "${temp_scores[0]}-${temp_scores[1]}")
                        .horizontal(context));
              },
            )
          : PageView(
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
                          controller: _courtController,
                          onPageChanged: (index) {
                            pageChanged(index);
                          },
                          itemCount: numOfCourts,
                          itemBuilder: (BuildContext context, int ind) {
                            return Column(
                              children: [
                                GenerateCourt(
                                        // if theres nobody on a court --> show empty court no scoreboard
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        courtProfiles: inGame[ind],
                                        countbutton: (widget.viewmode && !ih)
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Center(
                                                  child: Text('On Court',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white)),
                                                ),
                                              )
                                            : CountButton(
                                                [
                                                  countList[ind * 2],
                                                  countList[ind * 2 + 1]
                                                ],
                                                callback,
                                                ind,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                              ))
                                    .vertical(context),
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
                            'Round ${(index < numOfRounds) ? index + 1 : numOfRounds}',
                            style: TextStyle(
                                fontSize: 20, color: Color(0xffC49859))),
                      ),
                      Container(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Container(
                            //   child: SizedBox(
                            //     height: 50,
                            //     child: RaisedButton(
                            //         elevation: 0,
                            //         onPressed: () {
                            //           if (index > 0) {
                            //             if (index != numOfRounds) {
                            //               var ig =
                            //                   inGameUids[_currentCourtValue];
                            //               // set inGame at court index to variable
                            //               queue.addFirst(ig);
                            //               // take current inGame and add to queue

                            //               var next =
                            //                   queueFinished.removeFirst();
                            //               // set first in finished queue to var
                            //               print(
                            //                   'Moving set ${next[0]} ${next[1]} to inGame list');

                            //               for (var i = 0;
                            //                   i < courtHistory.length;
                            //                   i++) {
                            //                 if (courtHistory[i]
                            //                     .contains(next)) {
                            //                   inGameUids[i] = next;
                            //                   // set game where it was found on court
                            //                 }
                            //               }

                            //               print('Upcoming: ${queue.length}');
                            //               print('inGame: ${inGameUids.length}');
                            //               print(
                            //                   'Finished: ${queueFinished.length}');
                            //               setState(() {});
                            //             }
                            //             if (index % numOfCourts == 0) {
                            //               setState(() {
                            //                 index--;
                            //               });
                            //             }
                            //           }
                            //         },
                            //         color: Colors.transparent,
                            //         child: Text(
                            //           'Previous Match',
                            //           style: TextStyle(
                            //               color: Colors.blue[100],
                            //               fontSize: 20),
                            //         )),
                            //   ),
                            // ), -----> previous match button
                            Container(
                              child: Container(
                                height: 80,
                                child: (queueFinished.length ==
                                            numOfCourts * numOfRounds &&
                                        !widget.viewmode)
                                    ? AnimatedButton(
                                        onPressed: (_) async {
                                          var temp_prfs = widget.profiles;
                                          temp_prfs.sort((a, b) =>
                                              a.name.compareTo(b.name));
                                          var alphauid = temp_prfs
                                              .map((i) => i.uid)
                                              .toList();

                                          var game =
                                              Provider.of<GameData>(context);

                                          var parsedAllGames = {};

                                          allGames.forEach((key, value) {
                                            parsedAllGames[key.toString()] =
                                                value;
                                          });

                                          await updateAllGames(allGames);

                                          await GameDatabaseService()
                                              .updateGameData(
                                            widget.gameid,
                                            alphauid,
                                            game.type,
                                            game.groupId,
                                            numOfRounds,
                                            parsedAllGames,
                                            DateTime.now(),
                                            false,
                                            game.numOfCourts,
                                            getMapFromList(queue.toList()),
                                            getMapFromList(
                                                queueFinished.toList()),
                                            getMapFromList(inGameUids),
                                          );
                                          print('updating to firestore...');

                                          widget.profiles.forEach((profile) {
                                            Firestore.instance
                                                .collection('profiles')
                                                .document(profile.uid)
                                                .updateData(
                                                    {'status': 'Online'});
                                          });

                                          setState(() {
                                            finished = true;
                                          });

                                          setState(() {
                                            endbutton = false;
                                          });
                                        },
                                        text: 'End',
                                        ready: endbutton,
                                      )
                                    : ((!widget.viewmode || ih)
                                        ? ToggleButton(
                                            toggleFn: toggleCallback,
                                            onSlide: () {
                                              print(numOfRounds);
                                              print(index);
                                              if (index < numOfRounds) {
                                                print('we here');
                                                List scores = scoresCourt(
                                                    _currentCourtValue,
                                                    countList);

                                                bool side1wins = checkWinner(
                                                    _currentCourtValue, scores);

                                                var eloDif = eloDifSingle(
                                                    inGame[_currentCourtValue],
                                                    side1wins);

                                                var ig = inGameUids[
                                                    _currentCourtValue];
                                                queueFinished.addFirst(ig);
                                                // move set to finished queue
                                                // or person is on this court
                                                print(
                                                    'updating eights at index:');
                                                print(index);
                                                // updateRRcourt(
                                                //     inGame[_currentCourtValue],
                                                //     scores,
                                                //     eloDif,
                                                //     index); ----> updates to Database
                                                updateRREights(
                                                    inGame[_currentCourtValue],
                                                    scores,
                                                    index);
                                                updateMapGames(
                                                    allGames,
                                                    scores,
                                                    allGames.length,
                                                    _currentCourtValue,
                                                    ig);

                                                var historyCourt = courtHistory[
                                                    _currentCourtValue];
                                                historyCourt.add(ig);

                                                courtHistory[
                                                        _currentCourtValue] =
                                                    historyCourt;

                                                var next;
                                                if (queue.length > 0) {
                                                  next = queue.removeFirst();
                                                } else {
                                                  next = [];
                                                }

                                                inGameUids[_currentCourtValue] =
                                                    next;

                                                // if (queueFinished.length %
                                                //         numOfCourts ==
                                                //     0)
                                                //   setState(() {
                                                //     index++;
                                                //   });

                                                // update gamedata to firestore
                                                var temp_prfs = widget.profiles;
                                                temp_prfs.sort((a, b) =>
                                                    a.name.compareTo(b.name));
                                                var alphauid = temp_prfs
                                                    .map((i) => i.uid)
                                                    .toList();

                                                var game =
                                                    Provider.of<GameData>(
                                                        context);

                                                var parsedAllGames = {};

                                                allGames.forEach((key, value) {
                                                  parsedAllGames[
                                                      key.toString()] = value;
                                                });

                                                print('checkuh here');
                                                print(getMapFromList(
                                                    queue.toList()));
                                                // print(Map.fromIterable(
                                                //     queueFinished));
                                                // print(Map.fromIterable(inGameUids));

                                                GameDatabaseService()
                                                    .updateGameData(
                                                  widget.gameid,
                                                  alphauid,
                                                  game.type,
                                                  game.groupId,
                                                  numOfRounds,
                                                  parsedAllGames,
                                                  game.date,
                                                  true,
                                                  game.numOfCourts,
                                                  getMapFromList(
                                                      queue.toList()),
                                                  getMapFromList(
                                                      queueFinished.toList()),
                                                  getMapFromList(inGameUids),
                                                );
                                                print(countList);

                                                setState(() {
                                                  clearScoresOnCourt(
                                                      _currentCourtValue);
                                                });

                                                print(countList);
                                              }
                                            },
                                            active: weReadyToUpdate,
                                          )
                                        : Container()),
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
                    elevation: 0,
                    actions: [
                      // FlatButton(
                      //   child: Icon(
                      //     Icons.arrow_drop_up,
                      //     color: Colors.blue[100],
                      //     size: 40,
                      //   ),
                      //   onPressed: () {
                      //     _controller.animateTo(0,
                      //         duration: Duration(milliseconds: 200),
                      //         curve: Curves.ease);
                      //   },
                      // ),
                      FlatButton(
                        child: (viewUpcomingToggle)
                            ? Icon(
                                Icons.check_circle_outline,
                                color: Colors.blue[100],
                                size: 30,
                              )
                            : Icon(
                                Icons.check_circle,
                                color: Colors.blue[100],
                                size: 30,
                              ),
                        onPressed: () {
                          setState(() {
                            viewUpcomingToggle = !viewUpcomingToggle;
                          });
                        },
                      )
                    ],
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: Text(
                      viewUpcomingToggle ? 'Upcoming Games' : 'Finished Games',
                      style: TextStyle(color: Colors.blue[100], fontSize: 20),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  body: Container(
                    decoration: BoxDecoration(
                        border:
                            Border(top: BorderSide(color: Color(0xffC49859)))),
                    margin: EdgeInsets.only(bottom: 8.0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: (viewUpcomingToggle)
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: queue.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: 250,
                                  width: 400,
                                  child: GenerateCourt(
                                          courtProfiles: listUidToListProfiles(
                                              queue)[index],
                                          index: index,
                                          scores: '')
                                      .horizontal(context));
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: allGames.length,
                            itemBuilder: (context, ind) {
                              var temp_scores = allGames[ind]['scores'];
                              return InkWell(
                                child: Container(
                                    height: 250,
                                    width: 400,
                                    child: GenerateCourt(
                                            courtProfiles: List.generate(
                                                4,
                                                (index) => uidToProfile(
                                                    allGames[ind]['uids']
                                                        [index])),
                                            index: index,
                                            scores:
                                                "${temp_scores[0]}-${temp_scores[1]}")
                                        .horizontal(context)),
                                onLongPress: () {
                                  var newCountList = [];
                                  callbackEdit(List<int> newCount, int index) {
                                    // single callback function corresponding to index of count
                                    setState(() {
                                      newCountList.add(newCount[0]);
                                    });
                                    setState(() {
                                      newCountList.add(newCount[1]);
                                    });
                                  }

                                  List uids = allGames[ind]['uids'];
                                  List profs = uidToProfiles(uids);

                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.blue[900],
                                          title: Text('hello',
                                              style: TextStyle(
                                                  color: Colors.blue[100])),
                                          content: GenerateCourt(
                                              // if theres nobody on a court --> show empty court no scoreboard
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6,
                                              courtProfiles:
                                                  uidToProfiles(uids),
                                              countbutton: CountButton(
                                                [0, 0],
                                                callbackEdit,
                                                ind,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                              )).vertical(context),
                                          actions: [
                                            FlatButton(
                                              child: Text('Confirm',
                                                  style: TextStyle(
                                                      color: Colors.blue[100])),
                                              onPressed: () {
                                                var game = (ind / numOfCourts)
                                                        .truncate() +
                                                    1;
                                                for (var i = 0; i < 4; i++) {
                                                  Firestore.instance
                                                      .collection('profiles')
                                                      .document(profs[i].uid)
                                                      .updateData({
                                                    'eights': updateEights(
                                                        profs[i].eights,
                                                        game,
                                                        (i <= 1)
                                                            ? newCountList[0]
                                                            : newCountList[1])
                                                  });
                                                } // for doubles
                                                setState(() {
                                                  allGames[ind]['scores'] =
                                                      newCountList;
                                                });
                                                var parsedAllGames = {};

                                                allGames.forEach((key, value) {
                                                  parsedAllGames[
                                                      key.toString()] = value;
                                                });
                                                Firestore.instance
                                                    .collection('games')
                                                    .document(widget.gameid)
                                                    .updateData({
                                                  'scores': parsedAllGames
                                                });
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                              );
                            },
                          ),
                  ),
                )
              ],
            ),
    );
  }
}
