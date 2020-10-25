import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:OnceWing/screens/world/profile_tile_noGame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatefulWidget {
  Function(List<Profile>) callback;
  bool add;

  Leaderboard({Key key, this.callback, this.add}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Profile> playalist = [];

  @override
  Widget build(BuildContext context) {
    List<Profile> profiles = Provider.of<List<Profile>>(context) ?? [];

    profiles.sort((a, b) => b.rank.compareTo(a.rank));

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
        return InkWell(
            onTap: () {
              print('tap');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SafeArea(
                        top: true,
                        bottom: false,
                        child: Scaffold(
                            body: ProfileWrapper(
                          uid: profiles[index].uid,
                        )),
                      )));
            },
            child: ProfileTileNoGame(
              profile: profiles[index],
              callback: callbackProfile,
              add: widget.add,
            ));
      },
      shrinkWrap: false,
    );
  }
}
