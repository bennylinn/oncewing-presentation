import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/shared/constants.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> clans = ['None', 'Earth', 'Wind', 'Fire', 'Water'];

  // form values
  String _currentName;
  String _currentClan;
  double _currentRank;
  List<dynamic> _currentScore;
  int _currentGP;
  String _currentStatus;
  String photoUrl;
  int exp;
  String fcmToken;
  int fireRating;
  int waterRating;
  int windRating;
  int earthRating;
  Map raters;
  int feathers;
  List<dynamic> collection;
  String bio;
  String email;
  Map followers;
  Map following;

  var _controller1 = TextEditingController();
  var _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  Divider(
                    color: Colors.white,
                    height: 30.0,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue[400])),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.blue[100]),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue[100],
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    initialValue: userData.name,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    dropdownColor: Colors.black,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue[400])),
                        labelText: 'Clan',
                        labelStyle: TextStyle(color: Colors.blue[100]),
                        prefixIcon: Icon(
                          Icons.people,
                          color: Colors.blue[100],
                        )),
                    value: _currentClan ?? userData.clan,
                    items: clans.map((clan) {
                      return DropdownMenuItem(
                        value: clan,
                        child: Text(
                          '$clan Clan',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentClan = val),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            userData.uid,
                            _currentClan ?? userData.clan,
                            _currentName ?? userData.name,
                            _currentRank ?? userData.rank,
                            _currentScore ?? userData.eights,
                            _currentGP ?? userData.gamesPlayed,
                            _currentStatus ?? userData.status,
                            userData.wins,
                            userData.photoUrl,
                            userData.exp,
                            userData.fcmToken,
                            userData.fireRating,
                            userData.waterRating,
                            userData.windRating,
                            userData.earthRating,
                            userData.raters,
                            userData.feathers,
                            userData.collection,
                            userData.bio,
                            userData.email,
                            userData.followers,
                            userData.following,
                          );
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
