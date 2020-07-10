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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            var group = groups[index];
            var prfs = Provider.of<List<Profile>>(context) ?? [];
            prfs = prfs
                .where((profile) => group.uids.contains(profile.uid))
                .toList();

            return Card(
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                        trailing: Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.blue[100],
                        ),
                        title: Text(
                          '${group.groupName}',
                          style: TextStyle(color: Color(0xffC49859)),
                        ),
                        subtitle: Text(
                          '${group.type}',
                          style: TextStyle(color: Colors.blue[100]),
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
                        ])));
          }),
    );
  }
}
