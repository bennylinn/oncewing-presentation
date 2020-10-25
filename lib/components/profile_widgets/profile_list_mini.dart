import 'dart:collection';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/shared/ranking_algo.dart';
import 'package:OnceWing/components/profile_widgets/profile_tile_mini.dart';
import 'package:flutter/material.dart';

class MiniProfileList extends StatefulWidget {
  List<Profile> profiles;
  Function(List<Profile>) callback;
  bool showScore;
  Map scores;

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
    List<dynamic> profiles;
    Map scores;
    int rounds = (widget.scores.length / widget.profiles.length).round();
    Map uidScoreMap;
    var splayTreeMap;

    // prfs = Provider.of<List<Profile>>(context) ?? [];
    uids = widget.profiles.map((i) => i.uid).toList();
    profiles = widget.profiles;
    // profiles = prfs.where((item) => uids.contains(item.uid)).toList();
    profiles.sort((a, b) => a.name.compareTo(b.name));

    int eightSum(List listNums) {
      var sum = rounds * 21 - listNums.reduce((a, b) => a + b);
      return sum;
    }

    if (widget.showScore) {
      scores = widget.scores;

      uidScoreMap = parseScoresFromAllScores(scores);
      var sortedKeys = uidScoreMap.keys.toList(growable: false)
        ..sort((k1, k2) =>
            eightSum(uidScoreMap[k1]).compareTo(eightSum(uidScoreMap[k2])));
      splayTreeMap = new LinkedHashMap.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => uidScoreMap[k]);
      var orderedByGameScoreSum = [];
      splayTreeMap.forEach((key, value) {
        profiles.forEach((profile) {
          if (profile.uid == key) {
            orderedByGameScoreSum.add(profile);
          }
        });
      });

      profiles = orderedByGameScoreSum;
    }

    void callbackProfile(Profile profile) {
      if (playalist.contains(profile)) {
      } else {
        playalist.add(profile);
      }
      widget.callback(playalist);
    }

    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        var tempScores = [];
        if (widget.showScore) {
          tempScores = uidScoreMap[profiles[index].uid];
        }
        return MiniProfileTile(
          profile: profiles[index],
          scores: tempScores,
          showScore: widget.showScore,
        );
      },
      shrinkWrap: false,
    );
  }
}
