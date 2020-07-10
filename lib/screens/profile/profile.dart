import 'package:OnceWing/models/user.dart';
import 'package:OnceWing/screens/profile/edit_profile_page.dart';
import 'package:OnceWing/screens/profile/experience.dart';
import 'package:OnceWing/screens/profile/match_history.dart';
import 'package:OnceWing/screens/profile/stat_column.dart';
import 'package:OnceWing/screens/profile/stories.dart';
import 'package:OnceWing/screens/profile/story_repo.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/mediacache.dart';
import 'package:OnceWing/services/messaging.dart';
import 'package:OnceWing/services/storage.dart';
import 'package:OnceWing/shared/exp_loader.dart';
import 'package:OnceWing/shared/json_editor.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:OnceWing/shared/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({this.userData});

  final UserData userData;

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
    // sets profile image url
    CloudStorageService(uid: userData.uid)
        .getFirebaseProfileUrl()
        .then((value) {
      _url = value;
      CacheManagerr()
          .getFileInfo(value)
          .then((value) => profilePic = FileImage(value.file));
    });

    // sets stories first img url
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
  }

  nested(BuildContext context, Widget child, UserData user) {
    var _scrollcontroller =
        ScrollController(); // initialScrollOffset: !(_currentIndex==2) ? 270) ;

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
                    color: Colors.blue[100]),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    label,
                    style: TextStyle(
                        color: Colors.blue[100],
                        fontSize: 15.0,
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      color: backgroundcolor,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(5.0)),
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

          // already following user - should show unfollow button

          // does not follow user - should show follow button

          return buildFollowButton(
              text: "loading...",
              backgroundcolor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.grey);
        }

        return <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xff050E14),
            expandedHeight: 340,
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

                      Image showHelmet(int rank) {
                        if (rank < 1500) {
                          return Image(
                            image: AssetImage('assets/Silver.png'),
                          );
                        } else if (1700 <= rank) {
                          return Image(
                            image: AssetImage('assets/Plat.png'),
                          );
                        } else {
                          return Image(
                            image: AssetImage('assets/Gold.png'),
                          );
                        }
                      }

                      UserData userData;
                      int level;
                      if (snapshot.hasData) {
                        userData = snapshot.data;
                        level = Experience(userData.exp).level();

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
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: (userData.clan == 'None')
                                          ? AssetImage('assets/fullDragon.png')
                                          : AssetImage(
                                              'assets/${userData.clan}Wing.png'),
                                      fit: BoxFit.fitWidth),
                                ),
                                padding: EdgeInsets.only(
                                    top: 40, left: 10, right: 10, bottom: 0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        height: 150,
                                        child: Column(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // CircleAvatar(
                                            //   radius: 90,
                                            //   backgroundColor: Colors.transparent,
                                            // backgroundImage: (userData.rank >= 1700) ? AssetImage('assets/diamondWing.png') : (userData.rank>=1600) ? AssetImage('assets/platinum_wing.png') : AssetImage('assets/avatar_wing.png'),
                                            // child:
                                            InkWell(
                                              child: CircleAvatar(
                                                radius: 42,
                                                backgroundColor:
                                                    Colors.blue[200],
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 40,
                                                  // backgroundColor: Colors.transparent,
                                                  backgroundImage: AssetImage(
                                                      'assets/profile-icon-empty.png'),
                                                  child: !(_url == null ||
                                                          profilePic == null)
                                                      ? circularize(profilePic)
                                                      : Container(
                                                          height: 0,
                                                        ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StreamBuilder<Object>(
                                                              stream: null,
                                                              builder: (context,
                                                                  snapshot) {
                                                                return Whatsapp(
                                                                  profile:
                                                                      userData,
                                                                  image:
                                                                      makeThumbnail(
                                                                          _url),
                                                                );
                                                              })),
                                                );
                                              },
                                              onLongPress: () {
                                                if (currentUserId ==
                                                    userData.uid) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Share Story'),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    'Upload from gallery or take a picture.'),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            FlatButton(
                                                              child: Text(
                                                                  'Gallery'),
                                                              onPressed: () {
                                                                JsonEdit(
                                                                        uid: userData
                                                                            .uid)
                                                                    .getImage(
                                                                        'gallery',
                                                                        context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text(
                                                                  'Take Picture'),
                                                              onPressed: () {
                                                                JsonEdit(
                                                                        uid: userData
                                                                            .uid)
                                                                    .getImage(
                                                                        'camera',
                                                                        context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                }
                                              },
                                              onDoubleTap: () {
                                                if (currentUserId ==
                                                    userData.uid) {
                                                  JsonEdit(uid: userData.uid)
                                                      .deleteStory();
                                                  CloudStorageService(
                                                          uid: userData.uid)
                                                      .deleteStoryJson();
                                                }
                                              },
                                            ),
                                            // ),
                                            Spacer(
                                              flex: 2,
                                            ),
                                            Text(
                                              '${userData.name}',
                                              style: TextStyle(
                                                color: Color(0xffC49859),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Spacer(
                                              flex: 1,
                                            ),
                                            Text(
                                              '${userData.clan} Clan',
                                              style: TextStyle(
                                                color: Colors.blue[100],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        width: 80,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 80,
                                              width: 80,
                                              child: ExperienceLoader(
                                                child: showHelmet(
                                                    userData.rank.round()),
                                                size: 130,
                                                exp: userData.exp,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'Lvl $level',
                                                style: TextStyle(
                                                    color: Colors.blue[100]),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  buildStatColumn("rank",
                                                      userData.rank.round()),
                                                  buildStatColumn(
                                                      "wins", userData.wins),
                                                  buildStatColumn(
                                                      "followers",
                                                      userData
                                                          .followers.length),
                                                ],
                                              ),
                                            ),
                                            Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  buildProfileFollowButton(
                                                      userData),
                                                  buildFollowButton(
                                                      text: userData.status,
                                                      backgroundcolor:
                                                          Colors.white,
                                                      textColor:
                                                          (userData.status ==
                                                                  'In Game')
                                                              ? Colors.red
                                                              : Colors.green,
                                                      borderColor: Colors.grey,
                                                      function: () {})
                                                ]),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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

  // Firestore.instance
  //       .collection("insta_a_feed")
  //       .document(profileId)
  //       .collection("items")
  //       .document(currentUserId)
  //       .setData({
  //     "ownerId": profileId,
  //     "username": currentUserModel.username,
  //     "userId": currentUserId,
  //     "type": "follow",
  //     "userProfileImg": currentUserModel.photoUrl,
  //     "timestamp": DateTime.now()
  //   });
  // }

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

    Container buildUserPosts() {
      Future<List<AssetImage>> getPosts() async {
        List<AssetImage> posts = [
          AssetImage('assets/lux_wings.png'),
          AssetImage('assets/lux_wings.png'),
          AssetImage('assets/lux_wings.png'),
        ];
        // var snap = await Firestore.instance
        //     .collection('insta_posts')
        //     .where('ownerId', isEqualTo: profileId)
        //     .orderBy("timestamp")
        //     .getDocuments();
        // for (var doc in snap.documents) {
        //   posts.add(ImagePost.fromDocument(doc));
        // }
        // setState(() {
        //   postCount = snap.documents.length;
        // });  -----> Retreive List of Images from FireStore

        return posts;
      }

      return Container(
          child: FutureBuilder<List<AssetImage>>(
        future: getPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          else if (view == "grid") {
            // build the grid
            return Container(
              height: 400,
              child: Column(
                children: [
                  GridView.count(
                      primary: false,
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(0.5),
                      mainAxisSpacing: 1.5,
                      crossAxisSpacing: 1.5,
                      shrinkWrap: true,
                      children: snapshot.data.map((AssetImage imagePost) {
                        return GridTile(
                            child: ImageTile(Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/lux_wings.png'))))));
                      }).toList()),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          border:
                              Border.all(color: Colors.blue[100], width: 1)),
                      padding: EdgeInsets.all(0),
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                      child: (_highlightUrl == null)
                          ? Center(
                              child: Text('Highlight Reel',
                                  style: TextStyle(
                                      color: Colors.blue[100],
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400)),
                            )
                          : ((vp == null) ? Loading() : vp)),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: (userData.uid == currentUserId)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                color: Colors.blue[200],
                                child: Text('Upload'),
                                onPressed: () {
                                  CloudStorageService(uid: userData.uid)
                                      .uploadHighlightVid();
                                },
                              ),
                              FlatButton(
                                color: Colors.red[200],
                                child: Text('Delete'),
                                onPressed: () {
                                  CloudStorageService(uid: userData.uid)
                                      .deleteHighlight('Highlight.mp4');
                                },
                              )
                            ],
                          )
                        : Container(
                            height: 0,
                          ),
                  )
                ],
              ),
            );
          } else if (view == "feed") {
            return PlayerMatchHistory(uid: userData.uid);
          } else if (view == "history") {
            return StatColumn(
              uid: userData.uid,
            );
          }
        },
      ));
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
                          top: BorderSide(color: Color(0xffC49859), width: 3)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1],
                          colors: [Color(0xff021420), Color(0xff00484F)])),
                  child: ListView(
                    children: <Widget>[
                      buildImageViewButtonBar(),
                      Divider(
                        height: 1.0,
                        color: Colors.white,
                      ),
                      buildUserPosts(),
                      SizedBox(
                        height: 50,
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

  ImageTile(this.imagePost);

  clickedImage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return Center(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Photo',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: Image.asset('assets/logofire.jpg'),
                ),
              ],
            )),
      );
    }));
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => clickedImage(context),
        child: Container(
            child: Image.asset('assets/logofire.jpg', fit: BoxFit.cover)));
  }
}

void openProfile(BuildContext context, UserData userData) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return ProfilePage(userData: userData);
  }));
}
