import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/shared/multi_image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';

class Uploader extends StatefulWidget {
  UserData currentUserModel;
  Uploader({this.currentUserModel});
  _Uploader createState() => _Uploader();
}

class _Uploader extends State<Uploader> {
  var file;
  UserData currentUserModel;
  bool isImage = true;

  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final _globalKey = GlobalKey<ScaffoldState>();

  bool uploading = false;
  bool isMulti = false;

  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  bool isUploading = false;

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        // print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
            ),
          ),
        );
      }),
    );
  }

  void uploadImages() {
    // change the shite here
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          print(imageUrls[0]);
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          Firestore.instance
              .collection('world_feed')
              .document(documnetID)
              .setData({
            "username": widget.currentUserModel.name,
            "location": 'location',
            "likes": {},
            "mediaUrls": imageUrls,
            "description": 'description',
            "uid": widget.currentUserModel.uid,
            "image?": true,
            "timestamp": DateTime.now(),
          }).then((_) {
            SnackBar snackbar =
                SnackBar(content: Text('Uploaded Successfully'));
            _globalKey.currentState.showSnackBar(snackbar);
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  Future<dynamic> postImage(Asset imageFile) async {
    var uuid = Uuid().v1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    StorageUploadTask uploadTask =
        ref.putData((await imageFile.getByteData()).buffer.asUint8List());

    String downloadUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl;
  }

  Widget showUploadScreen(ismulti) {
    if (ismulti) {
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: Colors.white70,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: clearImage),
            title: const Text(
              'Post to',
              style: const TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: uploadImages,
                  child: Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ))
            ],
          ),
          body: ListView(
            children: <Widget>[
              PostForm(
                imageFile: file,
                descriptionController: descriptionController,
                locationController: locationController,
                loading: uploading,
                currentUserModel: currentUserModel,
              ),
              Divider(),
              Container(
                child: InkWell(
                  onTap: () {
                    if (images.length == 0) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              content: Text("No image selected",
                                  style: TextStyle(color: Colors.white)),
                              actions: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 30,
                                    child: Center(
                                        child: Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                )
                              ],
                            );
                          });
                    } else {
                      SnackBar snackbar = SnackBar(
                          content: Text('Please wait, we are uploading'));
                      _globalKey.currentState.showSnackBar(snackbar);
                      uploadImages();
                    }
                  },
                  child: Container(
                    width: 130,
                    height: 50,
                    child: Center(
                        child: Text(
                      "Upload Images",
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                ),
              ),
              Container(height: 150, child: buildGridView()),
            ],
          ));
    } else {
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: Colors.white70,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: clearImage),
            title: const Text(
              'Post to',
              style: const TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: postVid,
                  child: Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ))
            ],
          ),
          body: ListView(
            children: <Widget>[
              PostForm(
                imageFile: file,
                descriptionController: descriptionController,
                locationController: locationController,
                loading: uploading,
                currentUserModel: currentUserModel,
              ),
              Divider(),
            ],
          ));
    }
  }

  Widget build(BuildContext context) {
    currentUserModel = widget.currentUserModel;
    return file == null
        ? FlatButton.icon(
            label: Text('Upload a Post'),
            icon: Icon(Icons.file_upload),
            onPressed: () => {_selectImage(context)})
        : showUploadScreen(isMulti);
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Upload Pictures'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    isMulti = true;
                  });
                  setState(() {
                    file = File(".");
                  });
                  loadAssets();
                }),
            SimpleDialogOption(
                child: const Text('Upload a Video'),
                onPressed: () async {
                  setState(() {
                    isImage = false;
                  });
                  Navigator.of(context).pop();
                  File video = await ImagePicker()
                      .getVideo(
                        source: ImageSource.gallery,
                      )
                      .then((value) => File(value.path));
                  setState(() {
                    file = video;
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postVid() {
    setState(() {
      uploading = true;
    });
    if (isImage) {
      uploadImage(file).then((String data) {
        postToFireStore(
          description: descriptionController.text,
          location: locationController.text,
          isImage: isImage,
          currentUserModel: currentUserModel,
        );
      }).then((_) {
        setState(() {
          file = null;
          uploading = false;
        });
      });
    } else {
      uploadVideo(file).then((String data) {
        postToFireStore(
          mediaUrls: [data],
          description: descriptionController.text,
          location: locationController.text,
          isImage: isImage,
          currentUserModel: currentUserModel,
        );
      }).then((_) {
        setState(() {
          file = null;
          uploading = false;
        });
      });
    }
  }
}

class PostForm extends StatelessWidget {
  final imageFile;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final bool loading;
  final UserData currentUserModel;
  PostForm(
      {this.imageFile,
      this.descriptionController,
      this.loading,
      this.locationController,
      this.currentUserModel});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // CircleAvatar(
            //   backgroundImage: NetworkImage(currentUserModel.photoUrl),
            // ),
            Container(
              width: 250.0,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Write a caption...", border: InputBorder.none),
              ),
            ),
            Container(
              height: 45.0,
              width: 45.0,
              child: AspectRatio(
                aspectRatio: 487 / 451,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    alignment: FractionalOffset.topCenter,
                    image: FileImage(imageFile),
                  )),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none),
            ),
          ),
        )
      ],
    );
  }
}

Future<String> uploadImage(var imageFile) async {
  var uuid = Uuid().v1();
  StorageReference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
  StorageUploadTask uploadTask = ref.putFile(imageFile);

  String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  return downloadUrl;
}

Future<String> uploadVideo(var videoFile) async {
  var uuid = Uuid().v1();
  StorageReference ref = FirebaseStorage.instance.ref().child("post_$uuid.mp4");
  StorageUploadTask uploadTask =
      ref.putFile(videoFile, StorageMetadata(contentType: 'video/mp4'));

  String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  return downloadUrl;
}

void postToFireStore(
    {List<dynamic> mediaUrls,
    String location,
    String description,
    bool isImage,
    UserData currentUserModel}) async {
  var reference = Firestore.instance.collection('world_feed');

  reference.add({
    "username": currentUserModel.name,
    "location": location,
    "likes": {},
    "mediaUrls": mediaUrls,
    "description": description,
    "uid": currentUserModel.uid,
    "image?": isImage,
    "timestamp": DateTime.now(),
  }).then((DocumentReference doc) {
    String docId = doc.documentID;
    reference.document(docId).updateData({"postId": docId});
  });
}
