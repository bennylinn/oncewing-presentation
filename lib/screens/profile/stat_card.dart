import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';

InkWell getStructuredGridCellStat(index, UserData profile, User currentUser) {
  Color colour = Color(0xff050E14);
  String text = "";
  Map raters = profile.raters;
  int numRaters = raters.length;
  int votePercent;

  voteCounter(Map map, String element) {
    var counter = 0;
    raters.forEach((key, value) {
      if (value == element) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  percent(count, total) {
    if (total == 0) {
      return 0;
    } else {
      return (count / total) * 100;
    }
  }

  int fireRating = voteCounter(raters, 'fire');
  int windRating = voteCounter(raters, 'wind');
  int earthRating = voteCounter(raters, 'earth');
  int waterRating = voteCounter(raters, 'water');

  if (index == 0) {
    colour = Colors.redAccent;
    text = "Fire (Agressive)";
    votePercent = percent(fireRating, numRaters).round();
  } else if (index == 1) {
    colour = Colors.grey[700];
    text = "Wind (Speed)";
    votePercent = percent(windRating, numRaters).round();
  } else if (index == 2) {
    colour = Colors.brown;
    text = "Earth (Defense)";
    votePercent = percent(earthRating, numRaters).round();
  } else if (index == 3) {
    colour = Colors.blueAccent;
    text = "Water (Technical)";
    votePercent = percent(waterRating, numRaters).round();
  }

  return InkWell(
    child: new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: colour.withOpacity(0.1),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Color(0xffC49859), width: 1)),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  Spacer(),
                  Center(
                      child: Text(
                    text,
                    style: TextStyle(color: Color(0xffC49859), fontSize: 15),
                  )),
                  Spacer(),
                  Center(
                      child: FAProgressBar(
                    progressColor: colour,
                    currentValue: votePercent,
                    displayText: '%',
                  )),
                  Spacer(),
                ]),
          ),
        )),
    onTap: () {
      if (index == 0) {
        raters[currentUser.uid] = "fire";
        Firestore.instance
            .collection('profiles')
            .document(profile.uid)
            .updateData({'raters': raters});
      } else if (index == 1) {
        raters[currentUser.uid] = "wind";
        Firestore.instance
            .collection('profiles')
            .document(profile.uid)
            .updateData({'raters': raters});
      } else if (index == 2) {
        raters[currentUser.uid] = "earth";
        Firestore.instance
            .collection('profiles')
            .document(profile.uid)
            .updateData({'raters': raters});
      } else if (index == 3) {
        raters[currentUser.uid] = "water";
        Firestore.instance
            .collection('profiles')
            .document(profile.uid)
            .updateData({'raters': raters});
      }
    },
  );
}
