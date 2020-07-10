import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/modes/game_home.dart';
import 'package:OnceWing/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mode = GameHome();

    // return Material(
    //   child: mode,
    // );
    return StreamProvider<List<Profile>>.value(
        value: DatabaseService().profiles, child: mode);
  }
}
