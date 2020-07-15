import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/world/group_match_history.dart';
import 'package:OnceWing/screens/world/profile_list_noGame.dart';
import 'package:OnceWing/screens/world/register_game.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/group_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupInfo extends StatefulWidget {
  GroupData group;
  List<Profile> profiles;
  GroupInfo({this.group, this.profiles});

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  List<Profile> prfs;

  callbackProfiles(List<Profile> newProfiles) {
    setState(() {
      prfs = newProfiles;
    });
  }

  void _addPlayas(profiles) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MultiProvider(
          providers: [
            StreamProvider<List<Profile>>.value(
                value: DatabaseService().profiles),
            StreamProvider<List<GroupData>>.value(
                value: GroupDatabaseService().groupDatas)
          ],
          child: Container(
            color: Color(0xFF737373),
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                backgroundColor: Color(0xff050E14),
                centerTitle: true,
                title:
                    Text('Players', style: TextStyle(color: Colors.blue[100])),
                elevation: 0,
                actions: [
                  FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.add),
                      onPressed: () async {
                        var newUids = widget.group.uids;
                        var plustUids = List.generate(
                            prfs.length, (index) => prfs[index].uid);
                        plustUids = plustUids
                            .where((uid) => (!newUids.contains(uid)))
                            .toList();
                        newUids.addAll(plustUids);

                        GroupDatabaseService(groupid: widget.group.groupId)
                            .updateGroupData(
                                widget.group.groupName,
                                widget.group.groupId,
                                widget.group.type,
                                widget.group.bio,
                                widget.group.gameids,
                                newUids,
                                widget.group.managers,
                                widget.group.registration);
                        setState(() {});
                        Navigator.pop(context);
                      })
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(0),
                color: Color(0xffC49859),
                child: ProfileListNoGame(
                  callback: callbackProfiles,
                  profiles: profiles,
                  add: true,
                  group: widget.group,
                ),
              ),
            ),
          ),
        );
      },
      enableDrag: true,
      isScrollControlled: false,
    );
  }

  void popupAction(String selected) {
    print(selected);
    if (selected == 'Add Players') {
      _addPlayas(prfs);
    } else if (selected == 'Register a match') {
      registerGroup();
    }
  }

  void registerGroup() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Color(0xFF737373),
            appBar: AppBar(
              centerTitle: true,
              title: Text('Players', style: TextStyle(color: Colors.blue[100])),
              elevation: 0,
            ),
            body: RegisterRound(
              groupId: widget.group.groupId,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Container(
      color: Color(0xFF737373),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Color(0xff021420),
          centerTitle: true,
          title: Text('${widget.group.groupName}',
              style: TextStyle(color: Color(0xffC49859))),
          elevation: 0,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if ((widget.group.managers.contains(user.uid))) {
                  popupAction(value);
                }
              },
              child: Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'Add Players',
                    child: Text(
                      'Add Players',
                      style: TextStyle(
                          color: widget.group.managers.contains(user.uid)
                              ? Colors.black
                              : Colors.grey),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Register a match',
                    child: Text(
                      'Register a match',
                      style: TextStyle(
                          color: widget.group.managers.contains(user.uid)
                              ? Colors.black
                              : Colors.grey),
                    ),
                  ),
                ];
                ;
              },
              offset: Offset(0, 100),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.7, 1],
                  colors: [Color(0xff021420), Color(0xff00484F)])),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Text('Players',
                    style: TextStyle(fontSize: 20, color: Colors.blue[100])),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2 - 100,
                padding: EdgeInsets.all(0),
                color: Color(0xff021420),
                child: ProfileListNoGame(
                  profiles: widget.profiles,
                  add: false,
                  group: widget.group,
                ),
              ),
              Divider(
                color: Colors.white,
                thickness: 2,
                height: 0,
              ),
              GroupMatchHistory(
                group: widget.group,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
