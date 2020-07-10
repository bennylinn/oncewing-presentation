import 'package:OnceWing/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class JsonEdit {
  String uid;
  JsonEdit({this.uid});

  File jsonFile;
  Directory dir;
  String fileName = "myFile.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  void initState() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) fileContent = json.decode(jsonFile.readAsStringSync());
    });
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode({
      "data": [content]
    }));
  }

  void deleteFile(Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);

    file.deleteSync();
  }

  void deleteStoryJsonFile() {
    initState();
    print("Deleting file!");

    if (fileExists) {
      print("File exists");
      deleteFile(dir, "myFile.json");
    } else {
      print("File does not exist!");
    }
  }

  void writeToFile(String key, dynamic value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent['data'][0].addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    fileContent = json.decode(jsonFile.readAsStringSync());
  }

  void writeNewStory(String mediaType, String media, String duration,
      String caption, String when, String color) {
    Map<String, dynamic> content = {
      "mediaType": mediaType,
      "media": media,
      "duration": duration,
      "caption": caption,
      "when": when,
      "color": color
    };

    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent['data'].add(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    CloudStorageService(uid: uid).uploadFile(imageToUpload: jsonFile);
  }

  void deleteStory() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        fileContent = json.decode(jsonFile.readAsStringSync());
        print("File exists");
        Map<String, dynamic> jsonFileContent =
            json.decode(jsonFile.readAsStringSync());
        jsonFileContent['data'].removeAt(0);
        jsonFile.writeAsStringSync(json.encode(jsonFileContent));
        CloudStorageService(uid: uid).uploadFile(imageToUpload: jsonFile);
      } else {
        print("File does not exist!");
      }
    });
  }

  // Getting Camera Ready
  String _imageUrl;

  File _image;

  final picker = ImagePicker();

  Future getImage(String where, BuildContext context) async {
    initState();
    var pickedFile;

    if (where == "camera") {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else if (where == "gallery") {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 10,
      );
    }

    _image = File(pickedFile.path);

    CloudStorageService(uid: uid)
        .uploadStoryImage(imageToUpload: _image)
        .then((value) {
      _imageUrl = value.imageUrl;
      writeNewStory("image", _imageUrl, "8.0", "Pic", "5 minutes ago", "");
    });
  }
}
