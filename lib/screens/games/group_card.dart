import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/world/world_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCard extends StatefulWidget {
  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  @override
  Widget build(BuildContext context) {
    var groups = Provider.of<List<GroupData>>(context);
    groups.removeWhere((group) => (group.groupName == "Friendly"));

    return ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          var group = groups[index];
          var prfs = Provider.of<List<Profile>>(context) ?? [];
          prfs = prfs
              .where((profile) => group.uids.contains(profile.uid))
              .toList();

          return Container(
              child: ExpansionTile(
                  trailing: Container(
                    width: 80,
                    child: Row(
                      children: [
                        Text(
                          "Sun ",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 18),
                        ),
                        Text(
                          "7 PM",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  title: Text(
                    '${group.groupName}',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${group.type}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Events(
                    group: group,
                    mini: true,
                    profiles: prfs,
                  ),
                ),
              ]));
        });
  }
}
