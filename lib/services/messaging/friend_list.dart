import 'package:OnceWing/services/messaging/friend_tile.dart';
import 'package:OnceWing/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendList extends StatefulWidget {
  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<FriendList> {
  List<Profile> playalist = [];

  @override
  Widget build(BuildContext context) {
    List<Profile> profiles;

    profiles = Provider.of<List<Profile>>(context) ?? [];
    profiles.sort((a, b) => a.name.compareTo(b.name));

    int eightSum(Profile profile) {
      var sum = 147 - profile.eights.reduce((a, b) => a + b);
      return sum;
    }

    profiles.sort((a, b) => eightSum(a).compareTo(eightSum(b)));

    return Container(
      height: 350,
      child: ListView.builder(
        addAutomaticKeepAlives: true,
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          return FriendTile(
            profile: profiles[index],
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}
