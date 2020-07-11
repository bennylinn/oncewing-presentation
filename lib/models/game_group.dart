class GroupData {
  String groupName;
  String groupId;
  String type;
  String bio;
  List<dynamic> gameids;
  List<dynamic> uids;
  List<dynamic> managers;
  Map registration;

  GroupData(
      {this.groupName,
      this.groupId,
      this.type,
      this.bio,
      this.gameids,
      this.uids,
      this.managers,
      this.registration});
}
