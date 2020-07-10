import 'package:OnceWing/models/game_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class GroupDatabaseService {
  final String groupid;
  GroupDatabaseService({this.groupid});

  var uuid = Uuid().v1();

  // collection reference
  final CollectionReference groupCollection =
      Firestore.instance.collection('Groups');

  Future registerGroup(
    String groupName,
    String type,
    String bio,
    List<dynamic> uids,
    List<dynamic> managers,
  ) async {
    try {
      await updateGroupData(groupName, uuid, type, bio, [], uids, managers);
      return uuid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateGroupData(
    String groupName,
    String groupId,
    String type,
    String bio,
    List<dynamic> gameids,
    List<dynamic> uids,
    List<dynamic> managers,
  ) async {
    return await groupCollection.document(groupId).setData({
      'groupName': groupName,
      'groupid': groupId,
      'type': type,
      'bio': bio,
      'gameids': gameids,
      'uids': uids,
      'managers': managers,
    });
  }

  // Group list from snapshot
  List<GroupData> _groupListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GroupData(
        groupName: doc.data['groupName'] ?? '',
        groupId: doc.data['groupid'] ?? '',
        type: doc.data['type'] ?? '',
        bio: doc.data['bio'] ?? '',
        gameids: doc.data['gameids'] ?? [],
        uids: doc.data['uids'] ?? [],
        managers: doc.data['managers'] ?? [],
      );
    }).toList();
  }

  // userData from snapshot
  GroupData _groupDataFromSnapshot(DocumentSnapshot snapshot) {
    return GroupData();
  }

  // Get profile stream
  Stream<List<GroupData>> get groupDatas {
    return groupCollection.snapshots().map(_groupListFromSnapshot);
  }

  // get user doc stream
  Stream<GroupData> get groupData {
    return groupCollection
        .document(groupid)
        .snapshots()
        .map(_groupDataFromSnapshot);
  }
}
