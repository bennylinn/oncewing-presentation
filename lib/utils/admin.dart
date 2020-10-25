import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/services/group_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    List<Profile> profiles;

    profiles = Provider.of<List<Profile>>(context) ?? [];

    return Container(
        color: Colors.white,
        height: 600,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          child: Text('update group'),
          onPressed: () {
            var groupName = 'Sunday Night Drive';
            var groupId = 'QCchwNg3M7a91zG7XPcI';
            var type = 'ranked';
            var bio = 'Drive Badminton Centre';
            var gameIds = ['c1753200-b9af-11ea-de07-73d47c772444'];
            var uids = [];
            var managers = [];
            GroupDatabaseService(groupid: 'QCchwNg3M7a91zG7XPcI')
                .updateGroupData(
                    groupName, groupId, type, bio, gameIds, uids, managers, {});
          },
        )

        // return ListTile(
        //   title: Text(p.name),
        //   trailing: FlatButton(
        //     child: Text('Update New Model'),
        //     onPressed: () {
        // DatabaseService(uid: p.uid).updateUserData(
        //     p.uid,
        //     p.clan,
        //     p.name,
        //     p.rank,
        //     p.eights,
        //     p.gamesPlayed,
        //     'Online',
        //     0,
        //     '',
        //     0,
        //     '',
        //     0,
        //     0,
        //     0,
        //     0,
        //     {},
        //     500,
        //     [],
        //     '',
        //     '',
        //     {},
        //     {});
        //   },
        // ),
        // );
        );
  }
}
