import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user ojb based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(
          user.uid,
          'None',
          'New Playa',
          1500,
          [0, 0, 0, 0, 0, 0, 0],
          0,
          'Online',
          0,
          '',
          0,
          '',
          0,
          0,
          0,
          0,
          {},
          500,
          [],
          '',
          user.email,
          {},
          {});
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
          user.uid,
          'None',
          'New Playa',
          1500,
          [0, 0, 0, 0, 0, 0, 0],
          0,
          'Online',
          0,
          '',
          0,
          '',
          0,
          0,
          0,
          0,
          {},
          500,
          [],
          '',
          user.email,
          {},
          {});
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Profile createAnonProfile(index) {
    Profile prf = Profile(
        uid: index.toString(),
        name: "Player $index",
        rank: 1500,
        eights: [0, 0, 0, 0, 0, 0, 0],
        gamesPlayed: 0);
    return prf;
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  checkFireBaseStatus(snapshot) async {
    try {
      return snapshot.hasdata;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
