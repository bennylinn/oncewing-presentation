import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/modes/players.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:flutter/material.dart';

class GenerateCourt {
  int index;
  List<Profile> courtProfiles;
  String scores;
  Widget countbutton;
  double height;

  GenerateCourt(
      {this.height,
      this.courtProfiles,
      this.index,
      this.scores,
      this.countbutton});

  // add if doubles check

  Widget getBubble1(context, isSmall) {
    return InkWell(
        onTap: () {
          print('tap');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SafeArea(
                    top: true,
                    bottom: false,
                    child: Scaffold(
                        body: ProfileWrapper(
                      uid: courtProfiles[0].uid,
                    )),
                  )));
        },
        child: Container(
            child: PlayerBubble(
          profile: courtProfiles[0],
          small: isSmall,
        )));
  }

  Widget getBubble2(context, isSmall) {
    return InkWell(
        onTap: () {
          print('tap');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SafeArea(
                    top: true,
                    bottom: false,
                    child: Scaffold(
                        body: ProfileWrapper(
                      uid: courtProfiles[1].uid,
                    )),
                  )));
        },
        child: Container(
            child: PlayerBubble(
          profile: courtProfiles[1],
          small: isSmall,
        )));
  }

  Widget getBubble3(context, isSmall) {
    return InkWell(
        onTap: () {
          print('tap');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SafeArea(
                    top: true,
                    bottom: false,
                    child: Scaffold(
                        body: ProfileWrapper(
                      uid: courtProfiles[2].uid,
                    )),
                  )));
        },
        child: Container(
            child: PlayerBubble(
          profile: courtProfiles[2],
          small: isSmall,
        )));
  }

  Widget getBubble4(context, isSmall) {
    return InkWell(
        onTap: () {
          print('tap');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SafeArea(
                    top: true,
                    bottom: false,
                    child: Scaffold(
                        body: ProfileWrapper(
                      uid: courtProfiles[3].uid,
                    )),
                  )));
        },
        child: Container(
            child: PlayerBubble(
          profile: courtProfiles[3],
          small: isSmall,
        )));
  }

  Widget vertical(context) {
    return Container(
      height: height,
      width: 250,
      child: (courtProfiles.isEmpty)
          ? Container(
              height: 0,
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 99,
                            child: Container(child: getBubble1(context, false)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 99,
                            child: Container(child: getBubble2(context, false)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment(0, 0),
                    child: Center(
                      child: countbutton,
                    )),
                Expanded(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 99,
                            child: Container(child: getBubble3(context, false)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 99,
                            child: Container(child: getBubble4(context, false)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/woodCourt.png'),
        fit: BoxFit.fitHeight,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.dstATop),
      )),
    );
  }

  Widget horizontal(context) {
    return Column(
      children: [
        Container(
          height: 20,
        ),
        Container(
          height: 180,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 99,
                          child: Container(
                            child: getBubble1(context, true),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 99,
                          child: Container(child: getBubble2(context, true)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment(0, 0),
                      child: Center(
                          child: Text(
                        '$scores',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )))),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment(-0.25, 0),
                          height: 99,
                          child: Container(child: getBubble3(context, true)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment(-0.25, 0),
                          height: 99,
                          child: Container(child: getBubble4(context, true)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/court.png'),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.6), BlendMode.dstATop),
          )),
        ),
      ],
    );
  }
}
