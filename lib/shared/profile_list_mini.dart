import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/shared/profile_tile_mini.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniProfileList extends StatefulWidget {
  List<Profile> profiles;
  Function(List<Profile>) callback;
  bool showScore;
  List<dynamic> scores;

  MiniProfileList(
      {Key key, this.showScore, this.profiles, this.callback, this.scores})
      : super(key: key);

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<MiniProfileList> {
  List<Profile> playalist = [];

  @override
  Widget build(BuildContext context) {
    List<Profile> prfs;
    List<String> uids;
    List<Profile> profiles;
    List<dynamic> scores;
    int rounds = (widget.scores.length / widget.profiles.length).round();

    List<Profile> historyProfiles = [];

    prfs = Provider.of<List<Profile>>(context) ?? [];
    uids = widget.profiles.map((i) => i.uid).toList();
    profiles = prfs.where((item) => uids.contains(item.uid)).toList();
    profiles.sort((a, b) => a.name.compareTo(b.name));

    int eightSum(Profile profile) {
      var sum = 147 - profile.eights.reduce((a, b) => a + b);
      return sum;
    }

    if (!widget.showScore) {
      scores = widget.scores;
      segregateScores(scores, rounds, players) {
        var segScores = [];
        for (var i = 0; i <= players; i++) {
          var s = scores.getRange(i * rounds, (i + 1) * rounds).toList();
          segScores.add(s);
        }
        return segScores;
      }

      List<dynamic> s1 = scores.getRange(0, 7).toList();
      List<dynamic> s2 = scores.getRange(7, 14).toList();
      List<dynamic> s3 = scores.getRange(14, 21).toList();
      List<dynamic> s4 = scores.getRange(21, 28).toList();
      List<dynamic> s5 = scores.getRange(28, 35).toList();
      List<dynamic> s6 = scores.getRange(35, 42).toList();
      List<dynamic> s7 = scores.getRange(42, 49).toList();
      List<dynamic> s8 = scores.getRange(49, 56).toList();
      List<List<dynamic>> segregatedScores = [s1, s2, s3, s4, s5, s6, s7, s8];
      profiles.asMap().forEach((index, Profile profile) => historyProfiles.add(
          Profile(
              uid: profile.uid,
              name: profile.name,
              clan: profile.clan,
              eights: segregatedScores[index],
              rank: profile.rank)));

      historyProfiles.sort((a, b) => eightSum(a).compareTo(eightSum(b)));
    }

    profiles.sort((a, b) => eightSum(a).compareTo(eightSum(b)));

    void callbackProfile(Profile profile) {
      if (playalist.contains(profile)) {
      } else {
        playalist.add(profile);
      }
      print(playalist.length);
      widget.callback(playalist);
    }

    List<Profile> showProfiles;
    if (widget.showScore) {
      showProfiles = profiles;
    } else {
      showProfiles = historyProfiles;
    }

    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: showProfiles.length,
      itemBuilder: (context, index) {
        return MiniProfileTile(
          profile: showProfiles[index],
        );
      },
      shrinkWrap: false,
    );
  }
}
