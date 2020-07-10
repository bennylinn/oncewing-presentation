import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/profile/profile.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:provider/provider.dart';

class MiniProfileTile extends StatefulWidget {
  String uid;
  final Profile profile;

  MiniProfileTile({
    Key key,
    this.profile,
    this.uid,
  }) : super(key: key);

  @override
  _ProfileTile createState() => _ProfileTile();
}

class _ProfileTile extends State<MiniProfileTile> {
  bool clicked = false;

  Widget scores() {
    int sum;

    sum = 147 - widget.profile.eights.reduce((a, b) => a + b);

    return Row(
      children: <Widget>[
        Container(
          child: Text(
            widget.profile.eights[0].toString(),
            style: TextStyle(color: Colors.blue[100]),
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            widget.profile.eights[1].toString(),
            style: TextStyle(color: Colors.blue[100]),
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            widget.profile.eights[2].toString(),
            style: TextStyle(color: Colors.blue[100]),
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            widget.profile.eights[3].toString(),
            style: TextStyle(color: Colors.blue[100]),
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            widget.profile.eights[4].toString(),
            style: TextStyle(color: Colors.blue[100]),
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            widget.profile.eights[5].toString(),
            style: TextStyle(color: Colors.blue[100]),
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            widget.profile.eights[6].toString(),
            style: TextStyle(color: Colors.blue[100]),
          ),
        ),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),
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
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(0xff2E2E38),
                ),
                child: ListTile(
                  title: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Scaffold(
                                      body: ProfileWrapper(
                                    uid: widget.profile.uid,
                                  ))));
                        },
                        child: Text(
                          widget.profile.name,
                          style: TextStyle(color: Color(0xffC49859)),
                        )),
                  ),
                  subtitle: Text(
                    widget.profile.rank.toString(),
                    style: TextStyle(color: Colors.blue[100]),
                  ),
                  trailing: Container(width: 150, child: scores()),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
