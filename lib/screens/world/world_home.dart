import 'package:OnceWing/models/game.dart';
import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/games/group_card.dart';
import 'package:OnceWing/screens/world/add_group.dart';
import 'package:OnceWing/screens/world/feed.dart';
import 'package:OnceWing/screens/world/group_stream_wrapper.dart';
import 'package:OnceWing/screens/world/leaderboard.dart';
import 'package:OnceWing/screens/world/structuredGrid.dart';
import 'package:OnceWing/screens/world/uploader_wrapper.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/services/group_database.dart';
import 'package:OnceWing/shared/structured_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // VideoPlayerController _controller;
  String view;

  @override
  void initState() {
    super.initState();
    view = 'feed';
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  Row buildImageViewButtonBar() {
    Color isActiveButtonColor(String viewName) {
      if (view == viewName) {
        return Colors.blueAccent;
      } else {
        return Colors.white;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.video_library, color: isActiveButtonColor("feed")),
          onPressed: () {
            changeView("feed");
          },
        ),
        IconButton(
          icon: Icon(Icons.list, color: isActiveButtonColor("leaderboards")),
          onPressed: () {
            changeView("leaderboards");
          },
        ),
        IconButton(
          icon: Icon(Icons.group, color: isActiveButtonColor("groups")),
          onPressed: () {
            changeView("groups");
          },
        ),
      ],
    );
  }

  showButton(viewName) {
    if (view == 'groups') {
      return FloatingActionButton(
          child: Icon(Icons.group_add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Create Group'),
                    ),
                    backgroundColor: Colors.blue[900],
                    body: AddGroup(),
                  );
                });
          });
    } else if (view == 'feed') {
      User user = Provider.of<User>(context);

      return FloatingActionButton(
          child: Icon(Icons.file_upload),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StreamProvider.value(
                      value: DatabaseService(uid: user.uid).userData,
                      child: UploaderWrapper());
                });
          });
    } else if (view == 'leaderboards') {
      return FloatingActionButton(
          child: Icon(Icons.group_add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Create Group'),
                    ),
                    backgroundColor: Colors.blue[900],
                    body: AddGroup(),
                  );
                });
          });
    }
  }

  showView(viewName) {
    if (view == 'groups') {
      return Container(
        child: Column(
          children: [
            Center(
              child: Text('Groups',
                  style: TextStyle(
                      color: Color(0xffC49859),
                      fontSize: 20,
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(height: 10),
            Expanded(
              child: MultiProvider(
                  providers: [
                    StreamProvider<List<GameData>>.value(
                        value: GameDatabaseService().gameDatas),
                    StreamProvider<List<Profile>>.value(
                        value: DatabaseService().profiles),
                    StreamProvider<List<GroupData>>.value(
                        value: GroupDatabaseService().groupDatas)
                  ],
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: GroupCard(),
                  )),
            ),
          ],
        ),
      );
    } else if (viewName == 'leaderboards') {
      return StreamProvider.value(
          value: DatabaseService().profiles,
          child: Container(
              child: Column(
            children: [
              Text('Region Leaderboard',
                  style: TextStyle(
                      color: Color(0xffC49859),
                      fontSize: 20,
                      fontWeight: FontWeight.w300)),
              Expanded(
                child: Leaderboard(
                  add: false,
                ),
              ),
            ],
          )));
    } else if (viewName == 'feed') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        // width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text('Feed',
                style: TextStyle(
                    color: Color(0xffC49859),
                    fontSize: 20,
                    fontWeight: FontWeight.w300)),
            Expanded(child: Feed()),
          ],
        ),
        // child: VideoInListOfCards(_controller),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            Center(
              child: Text('OnceWing World',
                  style: TextStyle(
                      color: Color(0xffC49859),
                      fontSize: 25,
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(height: 10),
            // Container(
            //   child: MoveCamera(),
            // ), ---------------------> Maps (don't need for now)
            Divider(
              height: 0,
              thickness: 1,
              color: Color(0xffC49859),
            ),
            buildImageViewButtonBar(),
            Divider(
              height: 10,
              thickness: 1,
              color: Color(0xffC49859),
            ),
            Expanded(child: showView(view))
          ],
        ),
      ),
      Positioned(
        bottom: 15,
        right: 15,
        child: showButton(view),
      )
    ]);
  }
}

class Events extends StatefulWidget {
  bool mini;
  GroupData group;
  List<Profile> profiles;
  Events({this.mini, this.group, this.profiles});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> regList;

    void callbackRegList(String p) {
      var newp = widget.profiles.firstWhere((profile) => profile.uid == p);
      setState(() {
        regList.add(newp);
      });
      setState(() {});
    }

    if (widget.group.registration.isNotEmpty) {
      regList = widget.profiles
          .where((profile) =>
              widget.group.registration['entries'].contains(profile.uid))
          .toList();
    }

    print(regList);
    var user = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          (widget.group.registration.isNotEmpty)
              ? Container(
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Color(0xffC49859), width: 2),
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 250,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      children: List.generate(
                          widget.group.registration['numPlayer'], (index) {
                        return StructuredGridCellWorld(
                          profile:
                              (regList.length <= index) ? null : regList[index],
                          groupId: widget.group.groupId,
                          uid: user.uid,
                          callback: callbackRegList,
                        );
                      }),
                    ),
                  ),
                )
              : Container(
                  height: 0,
                ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                color: Colors.green[100],
                child: Text('Join Group'),
                onPressed: () {
                  var uids = widget.group.uids;

                  if (!widget.group.uids.contains(user.uid)) {
                    uids.add(user.uid);
                    Firestore.instance
                        .collection('Groups')
                        .document(widget.group.groupId)
                        .updateData({'uids': uids});
                  }
                },
              ),
              FlatButton(
                color: Colors.blue[100],
                child: Text('View Group'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SafeArea(
                          top: true,
                          bottom: false,
                          child: GroupInfoWrapper(
                            group: widget.group,
                            profiles: widget.profiles,
                          ))));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
