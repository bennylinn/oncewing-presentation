import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/profile/profile.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:provider/provider.dart';

class FriendTile extends StatefulWidget {
  String uid;
  final Profile profile;

  FriendTile({
    Key key,
    this.profile,
    this.uid,
  }) : super(key: key);

  @override
  _ProfileTile createState() => _ProfileTile();
}

class _ProfileTile extends State<FriendTile> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 0.0,
              borderOnForeground: true,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xffC49859)),
                  color: Color(0xff2E2E38),
                ),
                child: ListTile(
                    title: Container(
                      width: MediaQuery.of(context).size.width / 5,
                      child: InkWell(
                          onTap: () {
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
                          child: Text(
                            widget.profile.name,
                            style: TextStyle(color: Color(0xffC49859)),
                          )),
                    ),
                    subtitle: Text(
                      widget.profile.rank.toString(),
                      style: TextStyle(color: Colors.blue[100]),
                    ),
                    trailing: FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.message,
                          color: Color(0xffC49859),
                        ),
                        label: Text(
                          "Msg",
                          style: TextStyle(color: Color(0xffC49859)),
                        ))),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
