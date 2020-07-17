import 'package:OnceWing/messaging/friend_list.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/world/world_home.dart';
import 'package:OnceWing/screens/home/settings_form.dart';
import 'package:OnceWing/screens/modes/mode_wrapper.dart';
import 'package:OnceWing/screens/profile/profile_wrapper.dart';
import 'package:OnceWing/screens/shop/shop.dart';
import 'package:OnceWing/services/auth.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/storage.dart';
import 'package:OnceWing/shared/empty_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/shared/destination_view.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  int _bottomSelectedIndex = 2;

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

  final AuthService _auth = AuthService();

  // showUpgrade(BuildContext parentContext, String transition) {
  //   showGeneralDialog(
  //     barrierDismissible: false,
  //     barrierColor: Colors.black,
  //     transitionDuration: Duration(milliseconds: 300),
  //     context: context,
  //     pageBuilder: (BuildContext context, Animation animation, Animation secondAnimation) {
  //     // player.play("silverToGold.mp3");
  //     Future.delayed(Duration(seconds: 8), () {

  //       Navigator.of(context).pop(true);
  //     });
  //     return Container(
  //       height: MediaQuery.of(context).size.height,
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //           image: AssetImage('assets/$transition.gif'),
  //           fit: BoxFit.fitWidth
  //           )
  //         ),
  //       child: Container(
  //         height: MediaQuery.of(context).size.height,
  //         width: MediaQuery.of(context).size.width,
  //         child: FlatButton(
  //           child: Container(height: 0,),
  //           onPressed: () {Navigator.pop(context);},
  //         ),
  //       )
  //       );
  //     }
  //   );
  // }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  initState() {
    super.initState();
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }
  }

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  Widget buildPageView(UserData user) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        EmptyContainer(),
        Home(),
        ProfileWrapper(uid: user.uid),
        ModeWrapper(),
        Shop(),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
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

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          Widget _screen;

          UserData userData = snapshot.data;
          // List<Profile> profiles = Provider.of<List<Profile>>(context);

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
