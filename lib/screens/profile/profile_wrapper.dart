import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/profile/profile.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';

/// Wrapper for Profile Page
/// Either shows:
/// - loading screen
/// - profile page
///
/// Stream: UserData

class ProfileWrapper extends StatelessWidget {
  final String uid;
  ProfileWrapper({this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: uid).userData,
        builder: (context, snapshot) {
          Widget _screen = Loading();
          UserData userData = snapshot.data;

          if (snapshot.hasData) {
            _screen = new ProfilePage(
              userData: userData,
            );
          }

          return _screen;
        });
  }
}
