import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/profile/profile.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileWrapper extends StatelessWidget {
  String uid;
  ProfileWrapper({this.uid});

  @override
  Widget build(BuildContext context) {
    // return Material(
    //   child: mode,
    // );
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: uid).userData,
        builder: (context, snapshot) {
          Widget _screen = Loading();
          UserData userData = snapshot.data;

          if (snapshot.hasData) {
            _screen = ProfilePage(
              userData: userData,
            );
          }

          return _screen;
        });
  }
}
