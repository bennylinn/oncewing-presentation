import 'package:OnceWing/models/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class GameDatabaseService {
  final String gameid;
  GameDatabaseService({this.gameid});

  var uuid = Uuid().v1();

  // collection reference
  final CollectionReference gameCollection =
      Firestore.instance.collection('games');

  Future registerGame(List<String> uids, String type, String groupId) async {
    try {
      await updateGameData(
          uuid, uids, type, groupId, 0, [0], DateTime.now(), true);
      return uuid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateGameData(
      String gameid,
      List<String> uids,
      String type,
      String groupId,
      int round,
      List<dynamic> scores,
      DateTime date,
      bool live) async {
    return await gameCollection.document(gameid).setData({
      'gameid': gameid,
      'uids': uids,
      'type': type,
      'groupId': groupId,
      'round': round,
      'scores': scores,
      'date': date,
      'live': live,
    });
  }

  // prof list from snapshot
  List<GameData> _gameListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GameData(
        gameid: doc.data['gameid'] ?? '',
        uids: doc.data['uids'] ?? ['s'],
        type: doc.data['type'] ?? 'Friendly',
        groupId: doc.data['groupId'] ?? '',
        round: doc.data['round'] ?? 0,
        scores: doc.data['scores'] ?? [0],
        date: (doc.data['date'] as Timestamp).toDate() ?? DateTime.now(),
        live: doc.data['live'] ?? false,
      );
    }).toList();
  }

  // userData from snapshot
  GameData _gameDataFromSnapshot(DocumentSnapshot snapshot) {
    return GameData(
      gameid: gameid,
      uids: snapshot.data['uids'],
      type: snapshot.data['type'],
      groupId: snapshot.data['groupId'],
      round: snapshot.data['round'],
      scores: snapshot.data['scores'],
      date: (snapshot.data['date'] as Timestamp).toDate(),
      live: snapshot.data['live'],
    );
  }

  // Get profile stream
  Stream<List<GameData>> get gameDatas {
    return gameCollection.snapshots().map(_gameListFromSnapshot);
  }

  // get user doc stream
  Stream<GameData> get gameData {
    return gameCollection
        .document(gameid)
        .snapshots()
        .map(_gameDataFromSnapshot);
  }
}
