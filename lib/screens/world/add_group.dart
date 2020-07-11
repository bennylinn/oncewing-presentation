import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/group_database.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddGroup extends StatefulWidget {
  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  final _formKey = GlobalKey<FormState>();
  final List<String> type = ['ranked', 'friendly'];
  Map following;
  String _groupName;
  String _currentType = 'friendly';

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
                    initialValue: '',
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _groupName = val),
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
                        labelText: 'Type',
                        labelStyle: TextStyle(color: Colors.blue[100]),
                        prefixIcon: Icon(
                          Icons.people,
                          color: Colors.blue[100],
                        )),
                    value: _currentType ?? 'friendly',
                    items: type.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          '$type',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentType = val),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Create',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          GroupDatabaseService().registerGroup(_groupName,
                              _currentType, '', [user.uid], [user.uid], {});
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
