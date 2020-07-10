import 'package:cloud_firestore/cloud_firestore.dart';

class FeedData {
  String username;
  String location;
  Map likes;
  List<dynamic> mediaUrls;
  String description;
  String userUid;
  bool isImage;
  Timestamp timestamp;

  FeedData(
      {this.username,
      this.location,
      this.likes,
      this.mediaUrls,
      this.description,
      this.userUid,
      this.isImage,
      this.timestamp});
}
