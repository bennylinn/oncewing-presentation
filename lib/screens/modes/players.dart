import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';

class PlayerBubble extends StatelessWidget {
  //!!! Make smaller bubbles for horizontal courts

  final Profile profile;
  final bool small;
  PlayerBubble({this.profile, this.small});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          AssetImage img = AssetImage('assets/lux_wings.png');

          if (profile.clan == 'Earth') {
            img = AssetImage('assets/logoearth.jpg');
          }
          if (profile.clan == 'Wind') {
            img = AssetImage('assets/logowind.jpg');
          }
          if (profile.clan == 'Fire') {
            img = AssetImage('assets/logofire.jpg');
          }
          if (profile.clan == 'Water') {
            img = AssetImage('assets/logowater.jpg');
          }
          if (profile.clan == 'None') {
            img = AssetImage('assets/lux_wings.png');
          }

          bool isUser = (user.uid == profile.uid);

          Widget glowAvatar() {
            if (isUser) {
              return AvatarGlow(
                endRadius: small ? 23 : 40,
                glowColor: Color(0xffC49859),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Color(0xffC49859),
                  child: CircleAvatar(
                    radius: 21,
                    backgroundImage: img,
                  ),
                ),
              );
            } else {
              return CircleAvatar(
                radius: small ? 22 : 40,
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blue[100],
                  child: CircleAvatar(
                    radius: 21,
                    backgroundImage: img,
                  ),
                ),
              );
            }
          }

          if (snapshot.hasData) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  glowAvatar(),
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isUser ? Color(0xffC49859) : Colors.white,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
