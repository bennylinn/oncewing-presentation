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

  Future registerGame(List<String> uids, String type, Map games, String groupId,
      int numOfRound, int numOfCourts) async {
    try {
      await updateGameData(uuid, uids, type, groupId, numOfRound, games,
          DateTime.now(), true, numOfCourts, {}, {}, {});
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
      Map scores,
      DateTime date,
      bool live,
      int numOfCourts,
      Map upcomingGames,
      Map finishedGames,
      Map inGame) async {
    return await gameCollection.document(gameid).setData({
      'gameid': gameid,
      'uids': uids,
      'type': type,
      'groupId': groupId,
      'round': round,
      'scores': scores,
      'date': date,
      'live': live,
      'numOfCourts': numOfCourts,
      'upcomingGames': upcomingGames,
      'finishedGames': finishedGames,
      'inGame': inGame
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
          scores: doc.data['scores'] ?? {},
          date: (doc.data['date'] as Timestamp).toDate() ?? DateTime.now(),
          live: doc.data['live'] ?? false,
          numOfCourts: doc.data['numOfCourts'] ?? [],
          upcomingGames: doc.data['upcomingGames'] ?? [],
          finishedGames: doc.data['finishedGames'] ?? [],
          inGame: doc.data['inGame'] ?? []);
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
        numOfCourts: snapshot.data['numOfCourts'],
        upcomingGames: snapshot.data['upcomingGames'] ?? [],
        finishedGames: snapshot.data['finishedGames'] ?? [],
        inGame: snapshot.data['inGame'] ?? []);
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
