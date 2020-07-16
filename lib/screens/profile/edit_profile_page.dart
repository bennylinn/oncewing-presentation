import 'dart:io';

import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/storage.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({this.uid});

  String uid;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _imageUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 75);

    setState(() {
      _image = File(pickedFile.path);
    });

    CloudStorageService(uid: widget.uid)
        .uploadProfileImage(imageToUpload: _image)
        .then((value) {
      _imageUrl = value.imageUrl;
      Firestore.instance
          .collection('profiles')
          .document(widget.uid)
          .updateData({
        "photoUrl": value,
      });
    });
    print(_imageUrl);
  }

  Future getCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });

    CloudStorageService(uid: widget.uid)
        .uploadProfileImage(imageToUpload: _image)
        .then((value) {
      _imageUrl = value.imageUrl;
    });
    print(_imageUrl);
  }

  Widget circularize(FileImage image) {
    return new Container(
        width: 190.0,
        height: 190.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fitHeight,
              image: image,
            )));
  }

  changeProfilePhoto(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Upload from gallery or take a picture.'),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Gallery'),
              onPressed: () {
                getImage();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Take Picture'),
              onPressed: () {
                getCamera();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  applyChanges() {
    Firestore.instance.collection('profiles').document(widget.uid).updateData({
      "name": nameController.text,
      "bio": bioController.text,
    });
  }

  Widget buildTextField({String name, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance
            .collection('profiles')
            .document(widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          UserData user = UserData.fromDocument(snapshot.data);

          nameController.text = user.name;
          bioController.text = user.bio;

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: (_image == null)
                    ? CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage(
                            'assets/profile-icon-empty.png'), // NetworkImage(currentUserModel.photoUrl),
                        radius: 50.0,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 50.0,
                        child: circularize(FileImage(_image)),
                      ),
              ),
              FlatButton(
                  onPressed: () {
                    changeProfilePhoto(context);
                  },
                  child: Text(
                    "Change Photo",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    buildTextField(name: "Name", controller: nameController),
                    buildTextField(name: "Bio", controller: bioController),
                  ],
                ),
              ),
              // Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child:
              //         MaterialButton(onPressed: () {}, child: Text("Logout")))
            ],
          );
        });
  }
}
