import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/world/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploaderWrapper extends StatefulWidget {
  @override
  _UploaderWrapperState createState() => _UploaderWrapperState();
}

class _UploaderWrapperState extends State<UploaderWrapper> {
  @override
  Widget build(BuildContext context) {
    UserData currentUserModel = Provider.of<UserData>(context);
    return Uploader(currentUserModel: currentUserModel);
  }
}
