import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String clan;
  final int rank;
  final List<dynamic> eights; // ingame scores
  final int gamesPlayed;
  final String status;

  final int wins;
  final String photoUrl;
  final int exp;
  final String fcmToken;
  final int fireRating;
  final int waterRating;
  final int windRating;
  final int earthRating;
  final Map raters;
  final int feathers;
  final List<dynamic> collection;
  final String bio;
  final String email;
  final Map followers;
  final Map following;

  UserData({
    this.uid,
    this.name,
    this.clan,
    this.rank,
    this.eights,
    this.gamesPlayed,
    this.status,
    this.wins,
    this.photoUrl,
    this.exp,
    this.fcmToken,
    this.fireRating,
    this.waterRating,
    this.windRating,
    this.earthRating,
    this.raters,
    this.feathers,
    this.collection,
    this.bio,
    this.email,
    this.followers,
    this.following,
  });

  factory UserData.fromDocument(DocumentSnapshot document) {
    return UserData(
      uid: document['uid'],
      name: document['name'],
      clan: document['clan'],
      rank: document['rank'],
      eights: document['eights'],
      gamesPlayed: document['gamesPlayed'],

      // add this last
    );
  }
}
