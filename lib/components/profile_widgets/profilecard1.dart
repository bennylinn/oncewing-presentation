import 'package:OnceWing/models/user.dart';
import 'package:flutter/material.dart';

class ProfileCard1 extends StatelessWidget {
  final UserData userData;
  ProfileCard1({this.userData});

  AssetImage wing() {
    if (userData.clan == "Wind") {
      return AssetImage('assets/WindWing.png');
    } else if (userData.clan == "Water") {
      return AssetImage('assets/WaterWing.png');
    } else if (userData.clan == "Earth") {
      return AssetImage('assets/EarthWing.png');
    } else if (userData.clan == "Fire") {
      return AssetImage('assets/FireWing.png');
    } else {
      return AssetImage('assets/fullDragon.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
                colors: [Color(0xff142A3D), Color(0xff464C56)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
            image: DecorationImage(
              image: wing(),
              colorFilter: ColorFilter.mode(
                  Color(0xff24333D).withOpacity(0.6), BlendMode.dstIn),
            )),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              height: 30,
            ),
            Container(
                height: 210,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${userData.rank}',
                              style: TextStyle(
                                  color: Color(0xffC49859), fontSize: 42)),
                          Text('Rank',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${userData.gamesPlayed}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                Text('Games Played',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12))
                              ],
                            ),
                          ),
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${userData.wins}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                Text('Total Wins',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12))
                              ],
                            ),
                          ),
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                userData.gamesPlayed > 0
                                    ? Text(
                                        '${(userData.wins * 100 / userData.gamesPlayed).round()}%',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18))
                                    : Text('N/A',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                Text('Win Percentage',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12))
                              ],
                            ),
                          ),
                        ]),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
