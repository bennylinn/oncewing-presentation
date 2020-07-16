import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/group_database.dart';
import 'package:OnceWing/shared/constants.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDropdown extends StatefulWidget {
  Function callback;
  GroupDropdown({this.callback});

  @override
  _GroupDropdownState createState() => _GroupDropdownState();
}

class _GroupDropdownState extends State<GroupDropdown> {
  final _formKey = GlobalKey<FormState>();
  String groupName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GroupData>>(
        stream: GroupDatabaseService().groupDatas,
        builder: (context, snapshot) {
          List<GroupData> groups = snapshot.data;

          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    dropdownColor: Colors.black,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue[400])),
                        labelStyle: TextStyle(color: Colors.blue[100]),
                        prefixIcon: Icon(
                          Icons.people,
                          color: Colors.blue[100],
                        )),
                    value: "Friendly",
                    items: groups.map((group) {
                      return DropdownMenuItem(
                        value: group.groupName,
                        child: Text(
                          '${group.groupName}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => groupName = val);
                      GroupData yegroup = groups
                          .firstWhere((element) => element.groupName == val);
                      widget.callback(yegroup);
                    },
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
