import 'package:OnceWing/components/profile_widgets/profilecard1.dart';
import 'package:OnceWing/components/profile_widgets/profilecard2.dart';
import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/modes/go_to_live_game.dart';
import 'package:OnceWing/screens/profile/edit_profile_page.dart';
import 'package:OnceWing/shared/experience.dart';
import 'package:OnceWing/screens/profile/match_history.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/mediacache.dart';
import 'package:OnceWing/services/messaging.dart';
import 'package:OnceWing/services/storage.dart';
import 'package:OnceWing/shared/alert.dart';
import 'package:OnceWing/shared/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

class ProfilePage extends StatefulWidget {
  final UserData userData;
  const ProfilePage({this.userData});

  @override
  _ProfilePageState createState() => _ProfilePageState(this.userData);
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  String _url;
  var firstImgUrl;
  var firstStoryPic;
  String _highlightUrl;
  FileInfo fileInfo;
  VidPlayer vp;
  FileImage profilePic;

  makeThumbnail(url) {
    if (url == null) {
      return AssetImage('assets/logo.png');
    } else {
      return NetworkImage(url);
    }
  }

  @override
  initState() {
    super.initState();
    // Sets profile image url
    CloudStorageService(uid: userData.uid)
        .getFirebaseProfileUrl()
        .then((value) {
      _url = value;
      CacheManagerr()
          .getFileInfo(value)
          .then((value) => profilePic = FileImage(value.file));
    });

    // Sets stories first img url
    /*
    CloudStorageService(uid: userData.uid)
        .getStoryJsonUrl()
        .then((value) => Repository.getOnceWingStories(value))
        .then((value) {
      if (value.length != 0) {
        setState(() {
          firstImgUrl = value[0].media;
        });
        setState(() {
          firstStoryPic = makeThumbnail(value[0].media);
        });
      } else {
        setState(() {
          firstStoryPic = AssetImage('assets/logo.png');
        });
      }
    });

    CloudStorageService(uid: userData.uid).getHighlightUrl().then((value) {
      setState(() {
        _highlightUrl = value;
      });
      if (value != null) {
        CacheManagerr().getFileInfo(value).then((value) {
          setState(() {
            fileInfo = value;
          });
          vp = VidPlayer(
            fileInfo: value,
            fromFile: true,
          );
        });
      }
    });
    */
  }

  // Builds a nested sliver header
  nested(BuildContext context, Widget child, UserData user) {
    var _scrollcontroller = ScrollController();

    return NestedScrollView(
      controller: _scrollcontroller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        Column buildStatColumn(String label, int number) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                number.toString(),
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    label,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400),
                  ))
            ],
          );
        }

        Container buildFollowButton(
            {String text,
            Color backgroundcolor,
            Color textColor,
            Color borderColor,
            Function function}) {
          return Container(
            child: FlatButton(
                onPressed: function,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4)),
                  width: 80,
                  alignment: Alignment.center,
                  child: Text(text,
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold)),
                  height: 27.0,
                )),
          );
        }

        Container buildProfileFollowButton(UserData user) {
          final user = Provider.of<User>(context);
          currentUserId = user.uid;
          // viewing your own profile - should show edit button
          if (userData.followers.containsKey(currentUserId)) {
            isFollowing = true;
          } else {
            isFollowing = false;
          }
          if (currentUserId == userData.uid) {
            return buildFollowButton(
              text: "Edit Profile",
              backgroundcolor: Colors.white,
              textColor: Colors.grey[700],
              borderColor: Colors.grey,
              function: editProfile,
            );
          } else {
            if (isFollowing) {
              return buildFollowButton(
                text: "Unfollow",
                backgroundcolor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.grey,
                function: unfollowUser,
              );
            } else if (!isFollowing) {
              return buildFollowButton(
                text: "Follow",
                backgroundcolor: Colors.blue,
                textColor: Colors.white,
                borderColor: Colors.blue,
                function: followUser,
              );
            }
          }

          return buildFollowButton(
              text: "loading...",
              backgroundcolor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.grey);
        }

        return <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xff050E14),
            expandedHeight: 265,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: StreamBuilder<UserData>(
                    stream: DatabaseService(uid: userData.uid).userData,
                    builder: (context, snapshot) {
                      var _qrUIDtoAdd;
                      Function setQrUid(uid) {
                        setState(() {
                          _qrUIDtoAdd = uid;
                        });
                      }

                      UserData userData;
                      int level;
                      if (snapshot.hasData) {
                        userData = snapshot.data;
                        level = Experience(userData.exp).level();

                        return Container(
                          height: 265,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [
                                        0.1,
                                        0.5,
                                        0.9
                                      ],
                                      colors: [
                                        Color(0xff050E14),
                                        Color(0xff273741),
                                        Color(0xff050E14)
                                      ]),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Container(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black,
                                            image: DecorationImage(
                                                image: (_url == null ||
                                                        profilePic == null)
                                                    ? AssetImage(
                                                        'assets/profile-icon-empty.png')
                                                    : profilePic,
                                                fit: BoxFit.fitWidth)),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  '${userData.name}',
                                                  style: TextStyle(
                                                    color: Color(0xffC49859),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  'Vancouver, BC',
                                                  style: TextStyle(
                                                    color: Colors.blue[100],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    buildProfileFollowButton(
                                                        userData),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.lightBlue[900],
                                thickness: 1,
                                height: 0,
                              ),
                              Container(
                                color: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff050E14),
                                  ),
                                  height: 65,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        6) /
                                                    3,
                                                child: buildStatColumn("fans",
                                                    userData.followers.length),
                                              ),
                                              Container(
                                                width: 3,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        stops: [
                                                      0.1,
                                                      0.5,
                                                      0.9
                                                    ],
                                                        colors: [
                                                      Color(0xff050E14),
                                                      Color(0xff273741),
                                                      Color(0xff050E14)
                                                    ])),
                                              ),
                                              Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        6) /
                                                    3,
                                                child: buildStatColumn(
                                                    "following",
                                                    userData.following.length),
                                              ),
                                              Container(
                                                width: 3,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        stops: [
                                                      0.1,
                                                      0.5,
                                                      0.9
                                                    ],
                                                        colors: [
                                                      Color(0xff050E14),
                                                      Color(0xff273741),
                                                      Color(0xff050E14)
                                                    ])),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  child: Container(
                                                      child: Center(
                                                    child: Text('In Game',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: (userData
                                                                      .status ==
                                                                  'Online')
                                                              ? Colors.grey
                                                              : Colors.red,
                                                        )),
                                                  )),
                                                  onTap: () {
                                                    if (userData.status !=
                                                        'Online') {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  StreamProvider
                                                                      .value(
                                                                    value: DatabaseService()
                                                                        .profiles,
                                                                    child:
                                                                        GoLiveGame(
                                                                      gameid: userData
                                                                          .status,
                                                                    ),
                                                                  )));
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.lightBlue[900],
                                thickness: 1,
                                height: 0,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [
                                0.2,
                                0.5,
                                0.8
                              ],
                                  colors: [
                                Color(0xff050E14),
                                Color(0xff273741),
                                Color(0xff050E14)
                              ])),
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    })),
          )
        ];
      },
      body: child,
    );
  }

  @override
  bool get wantKeepAlive => true;

  final UserData userData;
  String currentUserId;
  String view = "grid"; // default view
  bool isFollowing;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  _ProfilePageState(this.userData);

  editProfile() {
    EditProfilePage editPage = EditProfilePage(
      uid: userData.uid,
    );

    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return Center(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
              title: Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context);
                    })
              ],
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: editPage,
                ),
              ],
            )),
      );
    }));
  }

  addToFollowerMap(map, uid) {
    map['$uid'] = DateTime.now();
    return map;
  }

  followUser() {
    var currentUser = Provider.of<User>(context);
    print('following user');
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });
    Firestore.instance.collection('profiles').document(userData.uid).updateData(
        {'followers': addToFollowerMap(userData.followers, currentUser.uid)});

    Messaging().sendAndRetrieveMessage(userData.fcmToken);
  }

  unfollowUser() {
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
  }

  Widget circularize(image) {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Row buildImageViewButtonBar() {
      Color isActiveButtonColor(String viewName) {
        if (view == viewName) {
          return Colors.blueAccent;
        } else {
          return Colors.white;
        }
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.video_library, color: isActiveButtonColor("grid")),
            onPressed: () {
              changeView("grid");
            },
          ),
          IconButton(
            icon: Icon(Icons.list, color: isActiveButtonColor("feed")),
            onPressed: () {
              changeView("feed");
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline,
                color: isActiveButtonColor("history")),
            onPressed: () {
              changeView("history");
            },
          ),
        ],
      );
    }

    PageController pageController = PageController(
      initialPage: 0,
      keepPage: false,
    );

    Container buildUserPosts() {
      return Container(
        height: 300,
        child: PageView(
          controller: pageController,
          children: <Widget>[
            ProfileCard1(
              userData: userData,
            ),
            ProfileCard2(userData: userData),
          ],
        ),
      );
    }

    return StreamBuilder(
        stream: Firestore.instance
            .collection('profiles')
            .document(userData.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          UserData user = UserData.fromDocument(snapshot.data);

          return Container(
            child: nested(
                context,
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.blue[900], width: 0.5)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1],
                          colors: [Color(0xff021420), Color(0xff00484F)])),
                  child: ListView(
                    children: <Widget>[
                      buildUserPosts(),
                      SizedBox(
                        height: 10,
                      ),
                      PlayerMatchHistory(
                        uid: userData.uid,
                      )
                    ],
                  ),
                ),
                user),
          );
        });
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }
}

class ImageTile extends StatelessWidget {
  final Widget imagePost;
  final String currentUid;
  final String profileId;

  ImageTile(this.imagePost, this.currentUid, this.profileId);

  final _globalKey = GlobalKey<ScaffoldState>();

  clickedImage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      popupAction(value) {
        if (value == "Upload") {
          CloudStorageService(uid: currentUid).uploadThreePic(1).then((_) {
            SnackBar snackbar =
                SnackBar(content: Text('Uploaded Successfully'));
            _globalKey.currentState.showSnackBar(snackbar);
          });
        } else if (value == "Delete") {
          showAlertDialog(
              context,
              "Delete Video",
              "Are you sure you want to delete this video?",
              print,
              'Highlight.mp4');
        }
      }

      return Center(
        child: Scaffold(
            appBar: AppBar(
                title: Text('Photo',
                    style: TextStyle(
                        color: Colors.blue[100], fontWeight: FontWeight.bold)),
                backgroundColor: Colors.black,
                actions: [
                  (currentUid == profileId)
                      ? PopupMenuButton(
                          onSelected: (value) {
                            popupAction(value);
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.blue[100],
                            size: 20,
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'Upload',
                                child: Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.blue[400]),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Delete',
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red[300]),
                                ),
                              ),
                            ];
                          })
                      : Container(
                          height: 0,
                        )
                ]),
            body: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 300,
                  child: imagePost,
                ),
              ],
            )),
      );
    }));
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => clickedImage(context), child: Container(child: imagePost));
  }
}

void openProfile(BuildContext context, UserData userData) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return ProfilePage(userData: userData);
  }));
}
