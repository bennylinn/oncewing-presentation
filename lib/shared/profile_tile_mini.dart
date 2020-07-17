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
    int rounds;

    rounds = widget.profile.eights.length;
    sum = rounds * 21 - widget.profile.eights.reduce((a, b) => a + b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 5,
                  );
                },
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemCount: rounds,
                itemBuilder: (context, index) {
                  return Container(
                    width: 10,
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
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
