import 'package:OnceWing/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StructuredGridCellWorld extends StatefulWidget {
  Profile profile;
  String groupId;
  String uid;
  Function(String) callback;

  StructuredGridCellWorld(
      {this.profile, this.groupId, this.uid, this.callback});

  @override
  _StructuredGridCellWorldState createState() =>
      _StructuredGridCellWorldState();
}

class _StructuredGridCellWorldState extends State<StructuredGridCellWorld> {
  Color colour = Color(0xff050E14);
  Map registration;

  @override
  initState() {
    super.initState();

    Firestore.instance
        .collection('Groups')
        .document(widget.groupId)
        .get()
        .then((value) {
      registration = value['registration'];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profile != null) {
      if (widget.profile.clan == "Fire") {
        colour = Colors.red[700];
      } else if (widget.profile.clan == "Wind") {
        colour = Colors.grey[700];
      } else if (widget.profile.clan == "Earth") {
        colour = Colors.brown;
      } else if (widget.profile.clan == "Water") {
        colour = Colors.blueAccent;
      }
    }
    return Card(
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
              child: (widget.profile != null)
                  ? new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                          Center(
                              child: Text(
                            widget.profile.name,
                            style: TextStyle(
                                color: Color(0xffC49859), fontSize: 15),
                          )),
                          Center(
                              child: Text(
                            widget.profile.rank.toString(),
                            style: TextStyle(
                                color: Colors.blue[100], fontSize: 12),
                          ))
                        ])
                  : Center(
                      child: FlatButton(
                        onPressed: () {
                          List ent = registration['entries'];
                          if (!ent.contains(widget.uid)) {
                            ent.add(widget.uid);
                            Firestore.instance
                                .collection('Groups')
                                .document(widget.groupId)
                                .updateData({
                              'registration': {
                                'entries': ent,
                                'numCourts': registration['numCourts'],
                                'numPlayer': registration['numPlayer'],
                                'numRounds': registration['numRounds']
                              }
                            });
                          }
                          print(ent);
                        },
                        onLongPress: () {},
                        child: Icon(
                          Icons.add,
                          color: Color(0xffC49859),
                        ),
                      ),
                    ),
            )));
    ;
  }
}
