import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class CloudStorageService {
  String uid;
  CloudStorageService({this.uid});

  final picker = ImagePicker();

  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
    @required String title,
  }) async {
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uid).child(imageFileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }

    return null;
  }

  Future<CloudStorageResult> uploadProfileImage({
    @required File imageToUpload,
  }) async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(uid)
        .child('Profile')
        .child('Profile');

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: 'Profile',
      );
    }

    return null;
  }

  Future<CloudStorageResult> uploadStoryImage({
    @required File imageToUpload,
  }) async {
    var imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(uid)
        .child('Story')
        .child(imageFileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }

    return null;
  }

  Future<CloudStorageResult> uploadFile({
    @required File imageToUpload,
  }) async {
    var imageFileName = "StoryFile";

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uid).child(imageFileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }

    return null;
  }

  Future deleteImage(String imageFileName) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uid).child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteStoryJson() async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uid).child('myFile.json');

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getFirebaseProfileUrl() async {
    try {
      final StorageReference storageRef = FirebaseStorage.instance
          .ref()
          .child(uid)
          .child('Profile')
          .child('Profile');
      var result = await storageRef.getDownloadURL();
      {}
      return result;
    } catch (error) {}
  }

  Future<dynamic> getStoryJsonUrl() async {
    try {
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(uid).child('StoryFile');
      var result = await storageRef.getDownloadURL();
      return result;
    } catch (error) {}
  }

// I worked it out. The point is you have to specify the metadata content type manually like so.

  Future uploadHighlightVid() async {
    try {
      final file = await picker.getVideo(source: ImageSource.gallery);
      final filee = File(file.path);

      StorageReference ref =
          FirebaseStorage.instance.ref().child(uid).child('Highlight.mp4');
      StorageUploadTask uploadTask =
          ref.putFile(filee, StorageMetadata(contentType: 'video/mp4'));

      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

      var downloadUrl = await storageSnapshot.ref.getDownloadURL();

      if (uploadTask.isComplete) {
        var url = downloadUrl.toString();
        return CloudStorageResult(
          imageUrl: url,
          imageFileName: 'Highlight.mp4',
        );
      }
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> getHighlightUrl() async {
    try {
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(uid).child('Highlight.mp4');
      var result = await storageRef.getDownloadURL();

      return result;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future deleteHighlight(String imageFileName) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uid).child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
