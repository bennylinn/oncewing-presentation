class Profile {
  final String uid;
  final String name;
  final String clan;
  final int rank;
  final List<dynamic> eights;
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

  Profile({
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
}
