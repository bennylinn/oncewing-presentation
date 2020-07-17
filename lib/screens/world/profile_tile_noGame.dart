import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/messaging.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:provider/provider.dart';

class ProfileTileNoGame extends StatefulWidget {
  String uid;
  Function(Profile) callback;
  final Profile profile;
  bool add;

  ProfileTileNoGame({Key key, this.profile, this.uid, this.callback, this.add})
      : super(key: key);

  @override
  _ProfileTile createState() => _ProfileTile();
}

class _ProfileTile extends State<ProfileTileNoGame> {
  bool clicked = false;

  scores(add) {
    if (widget.add) {
      return Container(
        width: 80,
        child: RaisedButton(
          elevation: 0,
          color: Colors.transparent,
          onPressed: () {
            widget.callback(widget.profile);
            setState(() {
              clicked = true;
            });
            Messaging().groupInviteMsg(widget.profile.fcmToken);
          },
          child: AnimatedContainer(
            width: 80,
            height: 40,
            color: clicked == false ? Color(0xFFD8D8D8) : Color(0xffC49859),
            duration: Duration(milliseconds: 300),
            child: clicked == true
                ? Icon(
                    Icons.check_circle,
                    color: Colors.black,
                  )
                : Icon(
                    Icons.add,
                    color: Color(0xff021420),
                  ),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          AssetImage img = AssetImage('assets/lux_wings.png');

          if (widget.profile.clan == 'Earth') {
            img = AssetImage('assets/logoearth.jpg');
          }
          if (widget.profile.clan == 'Wind') {
            img = AssetImage('assets/logowind.jpg');
          }
          if (widget.profile.clan == 'Fire') {
            img = AssetImage('assets/logofire.jpg');
          }
          if (widget.profile.clan == 'Water') {
            img = AssetImage('assets/logowater.jpg');
          }
          if (widget.profile.clan == 'None') {
            img = AssetImage('assets/lux_wings.png');
          }

          var clr = Colors.blue[100];

          if (snapshot.hasData) {
            if (userData.name == widget.profile.name) {
              clr = Colors.blue[300];
            } else {
              clr = Colors.blue[100];
            }
          }
          if (snapshot.hasData) {
            return Card(
              elevation: 0.0,
              color: clr,
              borderOnForeground: true,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xff2E2E38),
                    border: Border.all(width: 3, color: Color(0xff2E2E38))),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC49859), width: 2)),
                  child: Container(
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: img,
                        ),
                        title: Text(
                          widget.profile.name,
                          style: TextStyle(color: Color(0xffC49859)),
                        ),
                        subtitle: Text(
                          widget.profile.rank.toString(),
                          style: TextStyle(color: Colors.blue[100]),
                        ),
                        trailing: Container(
                          width: 175,
                          child: scores(widget.add),
                        )),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
