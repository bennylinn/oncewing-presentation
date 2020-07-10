import 'package:OnceWing/models/feed.dart';
import 'package:OnceWing/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FeedDatabaseService {
  final String feedId;
  final UserData currentUserModel;
  FeedDatabaseService({this.feedId, this.currentUserModel});

  var uuid = Uuid().v1();

  // collection reference
  final CollectionReference feedCollection =
      Firestore.instance.collection('world_feed');

  void postToFireStore(
      {List<dynamic> mediaUrls,
      String location,
      String description,
      bool isImage,
      UserData currentUserModel}) async {
    try {
      await feedCollection.add({
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
        feedCollection.document(docId).updateData({"postId": docId});
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateFeedData(
    String username,
    String location,
    Map likes,
    List<dynamic> mediaUrls,
    String description,
    String userUid,
    bool isImage,
    Timestamp timestamp,
  ) async {
    return await feedCollection.document(feedId).setData({
      "username": currentUserModel.name,
      "location": location,
      "likes": likes,
      "mediaUrls": mediaUrls,
      "description": description,
      "uid": userUid,
      "image?": isImage,
      "timestamp": timestamp,
    });
  }

  // prof list from snapshot
  List<FeedData> _feedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return FeedData(
        username: doc.data['username'] ?? '',
        location: doc.data['location'] ?? '',
        likes: doc.data['likes'] ?? {},
        mediaUrls: doc.data['mediaUrls'] ?? [],
        description: doc.data['description'] ?? '',
        userUid: doc.data['uid'] ?? '',
        isImage: doc.data['image?'] ?? true,
        timestamp: (doc.data['timestamp'] as Timestamp) ?? DateTime.now(),
      );
    }).toList();
  }

  // userData from snapshot
  FeedData _feedDataFromSnapshot(DocumentSnapshot snapshot) {
    return FeedData(
      username: snapshot.data['username'] ?? '',
      location: snapshot.data['location'] ?? '',
      likes: snapshot.data['likes'] ?? {},
      mediaUrls: snapshot.data['mediaUrls'] ?? [],
      description: snapshot.data['description'] ?? '',
      userUid: snapshot.data['uid'] ?? '',
      isImage: snapshot.data['isImage'] ?? true,
      timestamp: (snapshot.data['timestamp'] as Timestamp) ?? DateTime.now(),
    );
  }

  // Get profile stream
  Stream<List<FeedData>> get feedDatas {
    return feedCollection.snapshots().map(_feedListFromSnapshot);
  }

  // get user doc stream
  Stream<FeedData> get feedData {
    return feedCollection
        .document(feedId)
        .snapshots()
        .map(_feedDataFromSnapshot);
  }
}
