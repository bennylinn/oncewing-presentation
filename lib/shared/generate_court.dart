import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/modes/players.dart';
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

  Widget getBubble1() {
    return Container(
        child: PlayerBubble(
      profile: courtProfiles[0],
    ));
  }

  Widget getBubble2() {
    return Container(
        child: PlayerBubble(
      profile: courtProfiles[1],
    ));
  }

  Widget getBubble3() {
    return Container(
        child: PlayerBubble(
      profile: courtProfiles[2],
    ));
  }

  Widget getBubble4() {
    return Container(
        child: PlayerBubble(
      profile: courtProfiles[3],
    ));
  }

  Widget vertical() {
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
                            child: Container(
                              child: PlayerBubble(
                                profile: courtProfiles[0],
                                small: false,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 99,
                            child: Container(
                              child: PlayerBubble(
                                profile: courtProfiles[1],
                                small: false,
                              ),
                            ),
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
                            child: Container(
                              child: PlayerBubble(
                                profile: courtProfiles[2],
                                small: false,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 99,
                            child: Container(
                              child: PlayerBubble(
                                profile: courtProfiles[3],
                                small: false,
                              ),
                            ),
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

  Widget horizontal() {
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
                            child: PlayerBubble(
                              profile: courtProfiles[0],
                              small: true,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 99,
                          child: Container(
                            child: PlayerBubble(
                              profile: courtProfiles[1],
                              small: true,
                            ),
                          ),
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
                          child: Container(
                            child: PlayerBubble(
                              profile: courtProfiles[2],
                              small: true,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment(-0.25, 0),
                          height: 99,
                          child: Container(
                            child: PlayerBubble(
                              profile: courtProfiles[3],
                              small: true,
                            ),
                          ),
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
