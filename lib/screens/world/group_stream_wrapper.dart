import 'package:OnceWing/models/game.dart';
import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/world/group_info.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:OnceWing/services/group_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupInfoWrapper extends StatefulWidget {
  GroupData group;
  List<Profile> profiles;
  GroupInfoWrapper({this.group, this.profiles});
  @override
  _GroupInfoWrapperState createState() => _GroupInfoWrapperState();
}

class _GroupInfoWrapperState extends State<GroupInfoWrapper> {
  @override
  Widget build(BuildContext context) {
    final grp = GroupInfo(
      group: widget.group,
      profiles: widget.profiles,
    );
    return MultiProvider(
        providers: [
          StreamProvider<List<Profile>>.value(
              value: DatabaseService().profiles),
          StreamProvider<List<GroupData>>.value(
              value: GroupDatabaseService().groupDatas),
          StreamProvider<List<GameData>>.value(
              value: GameDatabaseService().gameDatas)
        ],
        child: GroupInfo(
          group: widget.group,
          profiles: widget.profiles,
        ));
  }
}
