import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/authenticate/authenticate.dart';
import 'package:OnceWing/screens/home/homepage.dart';
import 'package:OnceWing/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    final user = Provider.of<User>(context);

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.getToken().then((val) {
      // print('Token: ' + val);
      Firestore.instance
          .collection('profiles')
          .document(user.uid)
          .updateData({'fcmToken': val.toString()});
    });

    // _auth.signOut();
    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
