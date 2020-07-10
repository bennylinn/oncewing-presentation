class GameData {
  String gameid;
  String type;
  String groupId;
  List<dynamic> uids;
  int round;
  List<dynamic> scores;
  DateTime date;
  bool live;

  GameData(
      {this.gameid,
      this.type,
      this.groupId,
      this.uids,
      this.round,
      this.scores,
      this.date,
      this.live});
}
