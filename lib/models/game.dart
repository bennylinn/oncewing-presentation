class GameData {
  String gameid;
  String type;
  String groupId;
  List<dynamic> uids;
  int round;
  Map scores;
  DateTime date;
  bool live;
  int numOfCourts;
  Map upcomingGames;
  Map finishedGames;
  Map inGame;

  GameData(
      {this.gameid,
      this.type,
      this.groupId,
      this.uids,
      this.round,
      this.scores,
      this.date,
      this.live,
      this.numOfCourts,
      this.upcomingGames,
      this.finishedGames,
      this.inGame});
}
