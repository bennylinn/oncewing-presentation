import 'package:OnceWing/components/scrolled_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterRound extends StatefulWidget {
  final String groupId;
  const RegisterRound({this.groupId});
  @override
  _RegisterRoundState createState() => _RegisterRoundState();
}

class _RegisterRoundState extends State<RegisterRound> {
  int _numberOfPlayers;
  String _event;
  int _numberOfRounds;
  int _numberOfCourts;

  @override
  initState() {
    super.initState();
    _numberOfPlayers = 8;
    _event = "Doubles";
    _numberOfRounds = 7;
    _numberOfCourts = 2;
  }

  void setNumberOfPlayers(String val) {
    setState(() {
      _numberOfPlayers = int.parse(val);
    });
    print('Num players:' + _numberOfPlayers.toString());
  }

  void setEvent(String val) {
    setState(() {
      _event = val;
    });
    print('Event:' + _event);
  }

  void setNumberOfCourts(String val) {
    setState(() {
      _numberOfCourts = int.parse(val);
    });
    print('Num courts:' + _numberOfCourts.toString());
  }

  void setNumberOfRounds(String val) {
    setState(() {
      _numberOfRounds = int.parse(val);
    });
    print('Num rounds:' + _numberOfRounds.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/logo.png'),
      )),
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Column(
                children: [
                  Text(
                    'Players',
                    style: TextStyle(color: Colors.blue[100]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red[900], width: 2),
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5)),
                    height: 60,
                    width: 120,
                    child: ScrolledForm(
                      listItems: ['8', '10'],
                      onChanged: setNumberOfPlayers,
                    ),
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    'Courts',
                    style: TextStyle(color: Colors.blue[100]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red[900], width: 2),
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5)),
                    height: 60,
                    width: 120,
                    child: ScrolledForm(
                      listItems: List.generate(
                        2,
                        (index) => (index + 1).toString(),
                      ),
                      onChanged: setNumberOfCourts,
                    ),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Spacer(),
              Column(
                children: [
                  Text(
                    'Rounds',
                    style: TextStyle(color: Colors.blue[100]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red[900], width: 2),
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5)),
                    height: 60,
                    width: 120,
                    child: ScrolledForm(
                      listItems: List.generate(
                        10,
                        (index) => index.toString(),
                      ),
                      onChanged: setNumberOfRounds,
                    ),
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    'Event',
                    style: TextStyle(color: Colors.blue[100]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red[900], width: 2),
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5)),
                    height: 60,
                    width: 120,
                    child: ScrolledForm(
                      listItems: ['Doubles'],
                      onChanged: setEvent,
                    ),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffC49859)),
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[900],
            ),
            child: FlatButton.icon(
              color: Colors.transparent,
              label:
                  Text('Confirm', style: TextStyle(color: Color(0xffC49859))),
              icon: Icon(Icons.check_box, color: Color(0xffC49859)),
              onPressed: () {
                Firestore.instance
                    .collection('Groups')
                    .document(widget.groupId)
                    .updateData({
                  'registration': {
                    'numPlayer': _numberOfPlayers,
                    'numRounds': _numberOfRounds,
                    'numCourts': _numberOfCourts,
                    'event': _event,
                    'entries': []
                  }
                });
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
