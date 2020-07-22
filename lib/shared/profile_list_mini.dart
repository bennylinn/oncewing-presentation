import 'dart:collection';
import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/shared/meth.dart';
import 'package:OnceWing/shared/profile_tile_mini.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    SplayTreeMap splayTreeMap = SplayTreeMap.from({});

    prfs = Provider.of<List<Profile>>(context) ?? [];
    uids = widget.profiles.map((i) => i.uid).toList();
    profiles = prfs.where((item) => uids.contains(item.uid)).toList();
    profiles.sort((a, b) => a.name.compareTo(b.name));

    int eightSum(List listNums) {
      var sum = rounds * 21 - listNums.reduce((a, b) => a + b);
      return sum;
    }

    if (widget.showScore) {
      scores = widget.scores;

      uidScoreMap = parseScoresFromAllScores(scores);
      splayTreeMap = SplayTreeMap.from(
          uidScoreMap,
          (a, b) =>
              eightSum(uidScoreMap[a]).compareTo(eightSum(uidScoreMap[b])));
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
