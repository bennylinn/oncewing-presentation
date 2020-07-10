import 'package:OnceWing/models/game_group.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/world/profile_tile_noGame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileListNoGame extends StatefulWidget {
  List<Profile> profiles;
  Function(List<Profile>) callback;
  bool add;
  GroupData group;

  ProfileListNoGame(
      {Key key, this.profiles, this.callback, this.add, this.group})
      : super(key: key);

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileListNoGame> {
  List<Profile> playalist = [];

  @override
  Widget build(BuildContext context) {
    GroupData group = widget.group;
    List<Profile> profiles = Provider.of<List<Profile>>(context) ?? [];

    profiles = profiles.where((item) => group.uids.contains(item.uid)).toList();

    profiles.sort((a, b) => a.name.compareTo(b.name));

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
        return ProfileTileNoGame(
          profile: profiles[index],
          callback: callbackProfile,
          add: widget.add,
        );
      },
      shrinkWrap: false,
    );
  }
}
