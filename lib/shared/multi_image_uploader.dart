import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/shared/upload_images.dart';
import 'package:OnceWing/shared/view_images.dart';
import 'package:flutter/material.dart';

class MultiUploader extends StatefulWidget {
  UserData currentUserModel;
  MultiUploader({this.currentUserModel});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MultiUploader> {
  final _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Multiple Images'),
      ),
      body: UploadImages(
        globalKey: _globalKey,
        currentUserModel: widget.currentUserModel,
      ),
    );
  }
}
