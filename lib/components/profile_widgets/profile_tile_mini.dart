import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/components/player_bubbles/player_bubble_xtraS.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:OnceWing/services/database.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:provider/provider.dart';

class MiniProfileTile extends StatefulWidget {
  bool showScore;
  List scores;
  String uid;
  final Profile profile;

  MiniProfileTile({
    Key key,
    this.profile,
    this.uid,
    this.scores,
    this.showScore,
  }) : super(key: key);

  @override
  _ProfileTile createState() => _ProfileTile();
}

class _ProfileTile extends State<MiniProfileTile> {
  bool clicked = false;

  Widget scores() {
    int sum;
    int rounds;

    if (widget.showScore) {
      rounds = widget.scores.length;
      sum = rounds * 21 - widget.scores.reduce((a, b) => a + b);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Center(
                        child: Text(', ',
                            style: TextStyle(color: Colors.blue[100])));
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: rounds,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 18,
                      height: 18,
                      child: Center(
                        child: Text(
                          widget.scores[index].toString(),
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
      return Container(height: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

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
                  borderRadius: BorderRadius.circular(2.0),
                  color: Color(0xff2E2E38),
                  border: Border.all(color: Color(0xff2E2E38), width: 2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC49859), width: 2)),
                  child: ListTile(
                    title: Container(
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
                    trailing: Container(width: 210, child: scores()),
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
