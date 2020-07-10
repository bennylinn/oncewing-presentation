import 'package:flutter/material.dart';
import 'package:OnceWing/screens/modes/8v8.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:provider/provider.dart';

class Versus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Profile>>.value(
        value: DatabaseService().profiles,
        child: ListView(shrinkWrap: true, children: <Widget>[
          Eights(),
        ]));
  }
}
