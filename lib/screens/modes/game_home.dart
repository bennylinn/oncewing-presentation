import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/games/games.dart';
import 'package:OnceWing/screens/home/profile_list.dart';
import 'package:OnceWing/screens/modes/groups_dropdown.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/services/group_database.dart';
import 'package:OnceWing/shared/animated_button.dart';
import 'package:OnceWing/shared/qr.dart';
import 'package:OnceWing/shared/scrolled_form.dart';
import 'package:OnceWing/shared/structured_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class GameHome extends StatefulWidget {
  @override
  _GameHome createState() => new _GameHome();
}

class _GameHome extends State<GameHome> {
  // final player = AudioCache();

  List<Profile> profiles;
  int _numberOfPlayers;
  String _event;
  int _numberOfRounds;
  int _numberOfCourts;
  String _groupId;
  PageController _controller;

  @override
  initState() {
    super.initState();
    profiles = [];
    _numberOfPlayers = 8;
    _event = "Doubles";
    _numberOfRounds = 7;
    _numberOfCourts = 2;
    _controller = PageController(
      initialPage: 0,
    );
  }

  callbackProfiles(List<Profile> newProfiles) {
    setState(() {
      profiles = newProfiles;
    });
  }

  callbackGroupId(GroupData group) {
    setState(() {
      _groupId = group.groupId;
    });
    print(_groupId);
  }

  goEights(
      bool go, String gameid, int numCourts, int numPlayers, int numRounds) {
    if (go) {
      if (profiles.length == numPlayers) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EightsPage(
                  profiles: profiles,
                  viewmode: false,
                  gameid: gameid,
                  numOfCourts: numCourts,
                  numOfPlayers: numPlayers,
                  numOfRounds: numRounds,
                  init: true,
                )));
      }
    }
  }

  bool startButton = false;

  String gameid;
  bool _modeChosen = false;

  @override
  Widget build(BuildContext context) {
    void _addPlayas(gid, numRounds) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return MultiProvider(
            providers: [
              StreamProvider<List<Profile>>.value(
                  value: DatabaseService().profiles),
              StreamProvider<List<GroupData>>.value(
                  value: GroupDatabaseService(groupid: gid).groupDatas)
            ],
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
                  child: ProfileList(
                      showScore: false,
                      callback: callbackProfiles,
                      profiles: profiles,
                      gid: gid,
                      numOfRounds: numRounds),
                ),
              ),
            ),
          );
        },
        enableDrag: true,
        isScrollControlled: false,
      );
    }

    Widget addPlayaButton(bool modeChosen) {
      if (modeChosen) {
        return RaisedButton(
          color: Colors.transparent,
          elevation: 0.0,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xffC49859),
            child: CircleAvatar(
                backgroundColor: Colors.blue[900],
                radius: 19,
                child: new Icon(
                  Icons.add,
                  color: Color(0xffC49859),
                )),
          ),
          onPressed: () {
            _addPlayas(_groupId, _numberOfRounds);
          },
        );
      } else {
        return RaisedButton(
          color: Colors.transparent,
          elevation: 0.0,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                radius: 19,
                child: new Icon(
                  Icons.add,
                  color: Colors.grey,
                )),
          ),
          onPressed: () {},
        );
      }
    }

    // Future registerGame(List<String> uids) async {
    //   if(profiles.length==8){
    //     try {
    //       // create a new document for the user with the uid
    //       await DatabaseService().createGameData(uids, 0);
    //     } catch(e){
    //       print(e.toString());
    //       return null;
    //     }
    //   }
    // }

    List<String> profilesToUids(List<Profile> profiles) {
      var uids = profiles.map((i) => i.uid).toList();
      return uids;
    }

    String _qrUIDtoAdd;

    Function setQrUid(uid) {
      setState(() {
        _qrUIDtoAdd = uid;
      });
    }

    void setNumberOfPlayers(String val) {
      setState(() {
        _numberOfPlayers = int.parse(val);
      });
      print('Num players:' + _numberOfPlayers.toString());
    }

    void setEvent(String val) {
      setState(() {
        _event = val;
      });
      print('Event:' + _event);
    }

    void setNumberOfCourts(String val) {
      setState(() {
        _numberOfCourts = int.parse(val);
      });
      print('Num courts:' + _numberOfCourts.toString());
    }

    void setNumberOfRounds(String val) {
      setState(() {
        _numberOfRounds = int.parse(val);
      });
      print('Num rounds:' + _numberOfRounds.toString());
    }

    Widget chooseMode(BuildContext context) {
      return Container(
        padding: EdgeInsets.all(8),
        height: 200,
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                Column(
                  children: [
                    Text(
                      'Players',
                      style: TextStyle(color: Colors.blue[100]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red[900], width: 2),
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5)),
                      height: 60,
                      width: 120,
                      child: ScrolledForm(
                        listItems: ['8', '10', '12'],
                        onChanged: setNumberOfPlayers,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      'Courts',
                      style: TextStyle(color: Colors.blue[100]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red[900], width: 2),
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5)),
                      height: 60,
                      width: 120,
                      child: ScrolledForm(
                        listItems: List.generate(
                          3,
                          (index) => (index + 1).toString(),
                        ),
                        onChanged: setNumberOfCourts,
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Spacer(),
                Column(
                  children: [
                    Text(
                      'Rounds',
                      style: TextStyle(color: Colors.blue[100]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red[900], width: 2),
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5)),
                      height: 60,
                      width: 120,
                      child: ScrolledForm(
                        listItems: List.generate(
                          11,
                          (index) => index.toString(),
                        ),
                        onChanged: setNumberOfRounds,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      'Event',
                      style: TextStyle(color: Colors.blue[100]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red[900], width: 2),
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5)),
                      height: 60,
                      width: 120,
                      child: ScrolledForm(
                        listItems: ['Doubles'],
                        onChanged: setEvent,
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
            Spacer(),
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC49859)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.blue[900],
              ),
              child: FlatButton.icon(
                color: Colors.transparent,
                label:
                    Text('Confirm', style: TextStyle(color: Color(0xffC49859))),
                icon: Icon(Icons.check_box, color: Color(0xffC49859)),
                onPressed: () {
                  setState(() {
                    _modeChosen = true;
                  });
                  // print("num players: " + _numberOfPlayers.toString());
                  _controller.animateTo(MediaQuery.of(context).size.width,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
              ),
            )
          ],
        ),
      );
    }

    return StreamProvider<List<Profile>>.value(
      value: DatabaseService().profiles,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10),
          child: Stack(children: [
            ListView(children: [
              Container(
                height: 50,
                child: Center(
                  child: Text('Game Mode',
                      style: TextStyle(
                          color: Color(0xffC49859),
                          fontSize: 25,
                          fontWeight: FontWeight.w300)),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _controller,
                      children: [
                        Column(
                          children: [
                            GroupDropdown(
                              callback: callbackGroupId,
                            ),
                            Container(
                              child: Container(
                                child: Column(
                                  children: [
                                    Card(
                                      margin: EdgeInsets.all(8),
                                      elevation: 15,
                                      color: Colors
                                          .transparent, // Colors.blue.withOpacity(0.2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ExpansionTile(
                                            leading: Container(
                                                height: 40,
                                                width: 40,
                                                child: Center(
                                                    child: Image(
                                                  image: AssetImage(
                                                      'assets/swordshield.png'),
                                                ))),
                                            trailing: Container(
                                                height: 40,
                                                width: 40,
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: Colors.white,
                                                )),
                                            title: Center(
                                              child: Text(
                                                'Round Robin',
                                                style: TextStyle(
                                                    color: Colors.blue[100],
                                                    fontSize: 20),
                                              ),
                                            ),
                                            children: <Widget>[
                                              Container(
                                                width: 400,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                height: 250,
                                                child: MediaQuery.removePadding(
                                                  context: context,
                                                  removeTop: true,
                                                  child: chooseMode(context),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 80,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView(children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            leading: FlatButton(
                              onPressed: () {
                                _controller.animateTo(-1,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              child: Icon(Icons.arrow_back,
                                  color: Colors.blue[100]),
                            ),
                            elevation: 0,
                          ),
                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                    color: Color(0xffC49859), width: 2),
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: AssetImage('assets/logo.png'),
                                )),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 250,
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: (profiles.length == 0)
                                  ? Text('')
                                  : GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3,
                                      children: List.generate(profiles.length,
                                          (index) {
                                        return getStructuredGridCell(
                                            profiles[index]);
                                      }),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                addPlayaButton(_modeChosen),
                                RaisedButton(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Color(0xffC49859),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.blue[900],
                                        radius: 19,
                                        child: new Icon(
                                          Icons.border_clear,
                                          color: Color(0xffC49859),
                                        )),
                                  ),
                                  onPressed: () {
                                    var prfs =
                                        Provider.of<List<Profile>>(context) ??
                                            [];

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          User user =
                                              Provider.of<User>(context);
                                          return AlertDialog(
                                            title: Text("Scan Player"),
                                            content: Container(
                                                child: QR(
                                              uid: user.uid,
                                              callback: setQrUid,
                                            )),
                                            actions: [
                                              FlatButton(
                                                child: Text("Confirm"),
                                                onPressed: () {
                                                  Profile p;
                                                  prfs.forEach((profile) {
                                                    if (_qrUIDtoAdd ==
                                                        profile.uid) {
                                                      p = profile;
                                                      setState(() {
                                                        profiles.add(p);
                                                      });
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                                FlatButton(
                                  child: Text('Clear Players',
                                      style: TextStyle(
                                          color:
                                              Colors.red[500].withOpacity(0.6),
                                          fontSize: 15)),
                                  onPressed: () {
                                    setState(() {
                                      profiles = [];
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ])
                      ]))
            ]),
            Positioned(
              bottom: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    AnimatedButton(
                      text: 'Lock In',
                      onPressed: (_) {
                        var ft = GameDatabaseService().registerGame(
                            profilesToUids(profiles),
                            'ranked',
                            {},
                            _groupId,
                            _numberOfRounds,
                            _numberOfCourts);
                        ft.then((value) {
                          setState(() {
                            gameid = value;
                          });
                          setState(() {
                            startButton = true;
                          });
                        });
                      },
                      ready:
                          (profiles.length == _numberOfPlayers) ? true : false,
                    ),
                    Spacer(),
                    AnimatedButton(
                      text: 'Start',
                      onPressed: (_) {
                        goEights(true, gameid, _numberOfCourts,
                            _numberOfPlayers, _numberOfRounds);
                      },
                      ready: startButton,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class EightsPage extends StatefulWidget {
  int numOfPlayers;
  int numOfCourts;
  int numOfRounds;
  List<Profile> profiles;
  bool viewmode;
  String gameid;
  Map queueMap;
  Map queueFinishedMap;
  Map inGameUidsMap;
  bool init;

  EightsPage(
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

  @override
  _EightsPage createState() => new _EightsPage();
}

class _EightsPage extends State<EightsPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.gameid);
    var _profiles = widget.profiles;
    _profiles.sort((a, b) => a.name.compareTo(b.name));

    void _showPlayerPanel() {
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
                  child: ProfileList(
                    showScore: true,
                    profiles: _profiles,
                    numOfRounds: widget.numOfRounds,
                  ), //update
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
          // actions: [
          //   FlatButton(
          //     child: Icon(Icons.backspace,),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //   )
          // ],
          backgroundColor: Color(0xff021420),
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Round Robin',
            style: TextStyle(color: Color(0xffC49859)),
          )),
      body: Courts(
          profiles: _profiles,
          viewmode: widget.viewmode,
          gameid: widget.gameid,
          numOfCourts: widget.numOfCourts,
          numOfPlayers: widget.numOfPlayers,
          numOfRounds: widget.numOfRounds,
          queueMap: widget.queueMap,
          queueFinishedMap: widget.queueFinishedMap,
          inGameUidsMap: widget.inGameUidsMap,
          init: widget.init),
    );
  }
}
