import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  var _auth = AuthService();

  // collection reference
  final CollectionReference profCollection =
      Firestore.instance.collection('profiles');

  Future updateUserData(
    String uid,
    String clan,
    String name,
    double rank,
    List<dynamic> eights,
    int gamesPlayed,
    String status,
    int wins,
    String photoUrl,
    int exp,
    String fcmToken,
    int fireRating,
    int waterRating,
    int windRating,
    int earthRating,
    Map raters,
    int feathers,
    List<dynamic> collection,
    String bio,
    String email,
    Map followers,
    Map following,
  ) async {
    return await profCollection.document(uid).setData({
      'uid': uid,
      'clan': clan,
      'name': name,
      'rank': rank,
      'eights': eights,
      'gamesPlayed': gamesPlayed,
      'status': status,
      'wins': wins,
      'photoUrl': photoUrl,
      'exp': exp,
      'fcmToken': fcmToken,
      'fireRating': fireRating,
      'waterRating': waterRating,
      'windRating': windRating,
      'earthRating': earthRating,
      'raters': raters,
      'feathers': feathers,
      'collection': collection,
      'bio': bio,
      'email': email,
      'followers': followers,
      'following': following,
    });
  }

  // prof list from snapshot
  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Profile(
        uid: doc.data['uid'] ?? '',
        name: doc.data['name'] ?? '',
        clan: doc.data['clan'] ?? '',
        rank: doc.data['rank'] ?? -1,
        eights: doc.data['eights'] ?? [0, 0, 0, 0, 0, 0, 0],
        gamesPlayed: doc.data['gamesPlayed'] ?? -1.0,
        status: doc.data['status'] ?? '',
        wins: doc.data['wins'] ?? 0,
        photoUrl: doc.data['photoUrl'] ?? '',
        exp: doc.data['exp'] ?? 0,
        fcmToken: doc.data['fcmToken'] ?? '',
        fireRating: doc.data['fireRating'] ?? 0,
        waterRating: doc.data['waterRating'] ?? 0,
        windRating: doc.data['windRating'] ?? 0,
        earthRating: doc.data['earthRating'] ?? 0,
        raters: doc.data['raters'] ?? {},
        feathers: doc.data['feathers'] ?? 0,
        collection: doc.data['collections'] ?? [],
        bio: doc.data['bio'] ?? '',
        email: doc.data['email'] ?? '',
        followers: doc.data['followers'] ?? {},
        following: doc.data['following'] ?? {},
      );
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      clan: snapshot.data['clan'],
      rank: snapshot.data['rank'],
      eights: snapshot.data['eights'],
      gamesPlayed: snapshot.data['gamesPlayed'],
      status: snapshot.data['status'] ?? '',
      wins: snapshot.data['wins'] ?? 0,
      photoUrl: snapshot.data['photoUrl'] ?? '',
      exp: snapshot.data['exp'] ?? 0,
      fcmToken: snapshot.data['fcmToken'] ?? '',
      fireRating: snapshot.data['fireRating'] ?? 0,
      waterRating: snapshot.data['waterRating'] ?? 0,
      windRating: snapshot.data['windRating'] ?? 0,
      earthRating: snapshot.data['earthRating'] ?? 0,
      raters: snapshot.data['raters'] ?? {},
      feathers: snapshot.data['feathers'] ?? 0,
      collection: snapshot.data['collections'] ?? [],
      bio: snapshot.data['bio'] ?? '',
      email: snapshot.data['email'] ?? '',
      followers: snapshot.data['followers'] ?? {},
      following: snapshot.data['following'] ?? {},
    );
  }

  // Get profile stream
  Stream<List<Profile>> get profiles {
    return profCollection.snapshots().map(_profileListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    Stream<UserData> ud;

    void _checkFirebase() async {
      try {
        ud =
            profCollection.document(uid).snapshots().map(_userDataFromSnapshot);
      } catch (e) {
        _auth.signOut();
        ud = null;
        print(e.toString());
      }
    }

    _checkFirebase();

    return ud;
  }
}
