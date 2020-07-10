import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/home/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileList extends StatefulWidget {
  List<Profile> profiles;
  Function(List<Profile>) callback;
  bool showScore;
  String gid;
  int numOfRounds;

  ProfileList(
      {Key key,
      this.showScore,
      this.profiles,
      this.callback,
      this.gid,
      this.numOfRounds})
      : super(key: key);

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  List<Profile> playalist = [];

  @override
  Widget build(BuildContext context) {
    List<Profile> prfs;
    List<String> uids;
    List<Profile> profiles;
    List<GroupData> groups;
    GroupData group;

    if (!(widget.gid == null)) {
      groups = Provider.of<List<GroupData>>(context) ?? null;
    }

    int eightSum(Profile profile) {
      var sum =
          widget.numOfRounds * 21 - profile.eights.reduce((a, b) => a + b);
      return sum;
    }

    if (widget.showScore) {
      prfs = Provider.of<List<Profile>>(context) ?? [];
      uids = widget.profiles.map((i) => i.uid).toList();
      profiles = prfs.where((item) => uids.contains(item.uid)).toList();
      profiles.sort((a, b) => eightSum(a).compareTo(eightSum(b)));
    } else {
      profiles = Provider.of<List<Profile>>(context) ?? [];
      if (widget.gid != '') {
        group = groups.firstWhere((element) => element.groupId == widget.gid);
        print(group.groupName);
        profiles =
            profiles.where((item) => group.uids.contains(item.uid)).toList();
      }
      profiles.sort((a, b) => a.name.compareTo(b.name));
    }

    void callbackProfile(Profile profile) {
      if (playalist.contains(profile)) {
      } else {
        playalist.add(profile);
      }
      print(playalist.length);
      widget.callback(playalist);
    }

    // List<Profile> actualPlayers;
    // List<String> uids;

    // if(widget.showScore == true){
    //   setState(() {
    //     uids = widget.profiles.map((i) => i.uid).toList();
    //   });
    //   setState(() {
    //     actualPlayers = profiles.where((item) => uids.contains(item.uid)).toList();
    //   });
    // }else{
    //   setState(() {
    //     actualPlayers = profiles;
    //   });
    // }

    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return ProfileTile(
          profile: profiles[index],
          showScore: widget.showScore,
          callback: callbackProfile,
          numOfRounds: widget.numOfRounds,
        );
      },
      shrinkWrap: false,
    );
  }
}
