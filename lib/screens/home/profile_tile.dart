import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/modes/player_bubble.dart';
import 'package:OnceWing/screens/modes/player_bubble_xtraS.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/messaging.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:provider/provider.dart';

class ProfileTile extends StatefulWidget {
  String uid;
  Function(Profile) callback;
  bool showScore;
  int numOfRounds;
  final Profile profile;

  ProfileTile(
      {Key key,
      this.profile,
      this.showScore,
      this.uid,
      this.callback,
      this.numOfRounds})
      : super(key: key);

  @override
  _ProfileTile createState() => _ProfileTile();
}

class _ProfileTile extends State<ProfileTile> {
  bool clicked = false;

  Widget scores() {
    if (widget.showScore) {
      var sum = widget.numOfRounds * 21 -
          widget.profile.eights.reduce((a, b) => a + b);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 1,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.numOfRounds,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 18,
                      child: Center(
                        child: Text(
                          widget.profile.eights[index].toString(),
                          style: TextStyle(color: Colors.blue[100]),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Container(
            child: Text(
              '+$sum',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[400],
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        child: RaisedButton(
          elevation: 0,
          color: Colors.transparent,
          onPressed: () {
            widget.callback(widget.profile);
            setState(() {
              clicked = true;
            });
            Messaging().gameInviteMsg(widget.profile.fcmToken);
          },
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: clicked == false ? Color(0xFFD8D8D8) : Color(0xffC49859),
            ),
            width: 40,
            height: 40,
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
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xff2E2E38),
                    border: Border.all(color: Color(0xff2E2E38), width: 3)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC49859), width: 2)),
                  child: ListTile(
                      // leading: CircleAvatar(
                      //   radius: 25.0,
                      //   backgroundImage: img,
                      // ),
                      // title: Text(
                      //   widget.profile.name,
                      //   style: TextStyle(color: Color(0xffC49859)),
                      // ),
                      // subtitle: Text(
                      //   widget.profile.rank.toString(),
                      //   style: TextStyle(color: Colors.blue[100]),
                      // ),
                      title: SizedBox(
                        height: 60,
                      ),
                      leading: Container(
                        width: 80,
                        child: InkWell(
                            onTap: () {
                              print('tap');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => SafeArea(
                                        top: true,
                                        bottom: false,
                                        child: Scaffold(
                                            body: ProfileWrapper(
                                          uid: widget.profile.uid,
                                        )),
                                      )));
                            },
                            child: Container(
                                child: PlayerBubbleXS(
                              profile: widget.profile,
                            ))),
                      ),
                      trailing: Container(
                        width: 190,
                        child: scores(),
                      )),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
