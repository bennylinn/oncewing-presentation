import 'package:OnceWing/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/services/database.dart';
import 'package:provider/provider.dart';
import 'package:OnceWing/components/profile_widgets/profile_list.dart';

class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Profile>>.value(
        value: DatabaseService().profiles,
        child: ListView(shrinkWrap: true, children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            child: Text(
              'Players',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: Colors.blueGrey,
            height: 0,
            thickness: 2,
          ),
          Expanded(child: ProfileList()),
        ]));
  }
}
