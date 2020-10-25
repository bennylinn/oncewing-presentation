import 'package:OnceWing/services/messaging/friend_list.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/world/world_home.dart';
import 'package:OnceWing/screens/home/settings_form.dart';
import 'package:OnceWing/screens/modes/mode_wrapper.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:OnceWing/screens/shop/shop.dart';
import 'package:OnceWing/services/auth.dart';
import 'package:OnceWing/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/shared/destination_view.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

/// Home Wrapper Page
/// Wraps the following 5 pages:
/// - Temple Page
/// - World Page
/// - Profile Page (default page)
/// - Play Page
/// - Shope page
///
/// The wrapper include a bottom navbar to navigate between the pages

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  int _bottomSelectedIndex = 2;
  final AuthService _auth = AuthService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // Requests notification permissions for iOS upon first sign in
  @override
  initState() {
    super.initState();
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }
  }

  // Crops an image to a circular form
  Widget circularize(NetworkImage image) {
    return new Container(
        width: 190.0,
        height: 190.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fitHeight,
              image: image,
            )));
  }

  // Sets new page index state
  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  // Controller for page index
  PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  // Builds selected page view
  Widget buildPageView(UserData user) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Shop(),
        Home(),
        ProfileWrapper(uid: user.uid),
        ModeWrapper(),
        Shop(),
      ],
    );
  }

  // Animates to next page if bottom navbar is tapped
  void bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  // Builds the settings panel as a modal bottom sheet
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1],
                      colors: [Color(0xff021420), Color(0xff00484F)])),
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
              child: SettingsForm(),
            );
          },
          isScrollControlled: true);
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          Widget _screen;

          UserData userData = snapshot.data;
          _screen = SafeArea(
            bottom: false,
            top: true,
            maintainBottomViewPadding: true,
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              drawer: Drawer(
                  elevation: 0.0,
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xff2E2E38)),
                    child: ListView(
                      children: <Widget>[
                        new UserAccountsDrawerHeader(
                          decoration: BoxDecoration(color: Color(0xff2E2E38)),
                          accountName: Text(userData.name),
                          accountEmail: Text(userData.clan),
                          currentAccountPicture: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/profile-icon-empty.png'),
                          ),
                        ),
                        new Divider(
                          color: Colors.black,
                          height: 5.0,
                        ),
                        StreamProvider.value(
                            value: DatabaseService().profiles,
                            child: FriendList()),
                        new Divider(
                          color: Colors.black,
                          height: 5.0,
                        ),
                        new ListTile(
                          title: Text(
                            'Settings',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () => _showSettingsPanel(),
                        ),
                        new Divider(
                          color: Colors.black,
                          height: 5.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 50.0, right: 50.0),
                          child: new RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)),
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text(
                                'Sign Out',
                              ),
                              onPressed: () async {
                                await _auth.signOut();
                              }),
                        )
                      ],
                    ),
                  )),
              body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1],
                          colors: [Color(0xff021420), Color(0xff00484F)])),
                  child: buildPageView(userData)),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _bottomSelectedIndex,
                onTap: (int index) {
                  setState(() {
                    bottomTapped(index);
                  });
                },
                items: allDestinations.map((Destination destination) {
                  return BottomNavigationBarItem(
                      icon: Icon(
                        destination.icon,
                        color: Color(0xffC49859),
                      ),
                      backgroundColor: Colors.black,
                      title: Center(
                          child: Text(
                        destination.title,
                        style: TextStyle(color: Color(0xffC49859)),
                      )));
                }).toList(),
              ),
            ),
          );
          return _screen;
        });
  }
}
