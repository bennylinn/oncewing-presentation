import 'package:OnceWing/models/profile.dart';
import 'package:flutter/material.dart';

Card getStructuredGridCell(Profile profile) {
  Color colour = Color(0xff050E14);

  if (profile.clan == "Fire") {
    colour = Colors.red[700];
  } else if (profile.clan == "Wind") {
    colour = Colors.grey[700];
  } else if (profile.clan == "Earth") {
    colour = Colors.brown;
  } else if (profile.clan == "Water") {
    colour = Colors.blueAccent;
  }

  return new Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: colour.withOpacity(0.8),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Color(0xffC49859), width: 1)),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Center(
                    child: Text(
                  profile.name,
                  style: TextStyle(color: Color(0xffC49859), fontSize: 15),
                )),
                Center(
                    child: Text(
                  profile.rank.toString(),
                  style: TextStyle(color: Colors.blue[100], fontSize: 12),
                ))
              ]),
        ),
      ));
}
