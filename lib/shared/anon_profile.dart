import 'package:OnceWing/models/profile.dart';
import 'package:flutter/material.dart';

class Anon {
  Profile createAnonProfile(index) {
    Profile prf = Profile(
        uid: index.toString(),
        name: "Player $index",
        rank: 1500.0,
        eights: [0, 0, 0, 0, 0, 0, 0],
        gamesPlayed: 0);
    return prf;
  }
}
