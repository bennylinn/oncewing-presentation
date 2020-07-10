import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/profile/stat_card.dart';
import 'package:OnceWing/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

class StatColumn extends StatelessWidget {
  String uid;
  StatColumn({this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService(uid: uid).userData,
        builder: (context, snapshot) {
          UserData profile = snapshot.data;
          User _currentUser = Provider.of<User>(context);
          showPercentLevel(exp) {
            if (exp < 200) {
              return exp / 2;
            }
            if (exp < 450) {
              return (exp - 200) / 2.5;
            }
            if (exp < 800) {
              return (exp - 450) / 3.5;
            }
            if (exp < 1200) {
              return (exp - 800) / 4;
            } else {
              return 100;
            }
          }

          return Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Center(
                      child: Text(
                    'Player Profile',
                    style: TextStyle(color: Color(0xffC49859), fontSize: 20),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Experience',
                          style: TextStyle(color: Colors.blue[100]),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Container(
                          height: 30,
                          width: 200,
                          child: FAProgressBar(
                            progressColor: Colors.blue[200],
                            currentValue: showPercentLevel(profile.exp).round(),
                            displayText: '%',
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    child: GridView.count(
                        primary: false,
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        children: List.generate(4, (index) {
                          return getStructuredGridCellStat(
                              index, profile, _currentUser);
                        })),
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                  color: Color(0xffC49859), width: 1)),
                          child: Center(
                            child: PrettyQr(
                                elementColor: Colors.black,
                                image: AssetImage('assets/logo.png'),
                                typeNumber: 3,
                                size: 125,
                                data: uid,
                                roundEdges: true),
                          ),
                        ),
                      )),
                ],
              ));
        });
  }
}
