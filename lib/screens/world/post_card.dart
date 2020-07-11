import 'package:OnceWing/my_flutter_app_icons.dart';
import 'package:OnceWing/shared/video_player.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:OnceWing/services/mediacache.dart';

class PostCard extends StatefulWidget {
  final String title;
  final List<dynamic> urls;
  final String owner;
  final bool isImage;
  const PostCard({this.title, this.urls, this.owner, this.isImage});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  VidPlayer vp;
  List _listOfImages = [];
  bool imagesLoaded = false;
  bool liked = false;
  @override
  initState() {
    super.initState();
    if (widget.isImage) {
      for (int i = 0; i < widget.urls.length; i++) {
        CacheManagerr().getFileInfo(widget.urls[i]).then((value) {
          _listOfImages.add(Image.file(value.file));

          if (i == widget.urls.length - 1) {
            setState(() {
              imagesLoaded = true;
            });
          }
        });
      }
    } else {
      CacheManagerr().getFileInfo(widget.urls[0]).then((value) {
        setState(() {
          vp = VidPlayer(
            fileInfo: value,
            fromFile: true,
          );
        });
      });
    }
  }

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
      icon = FontAwesomeIcons.solidHeart;
    } else {
      icon = FontAwesomeIcons.heart;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          // _likePost(postId);
          setState(() {
            liked = true;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    print(imagesLoaded);
    return Card(
        child: Column(children: <Widget>[
      Column(
        children: <Widget>[
          new ListTile(
            leading: Icon(
              MyFlutterApp.logo__2_,
              color: Color(0xffC49859),
            ),
            title: Text(widget.title),
          ),
          Container(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.width * 3.2 / 4,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                  ),
                  Container(
                    margin: EdgeInsets.all(0.0),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: (widget.isImage)
                        ? (imagesLoaded)
                            ? Carousel(
                                dotSize: 3,
                                boxFit: BoxFit.fitHeight,
                                images: _listOfImages,
                                autoplay: false,
                                indicatorBgPadding: 5.0,
                                dotPosition: DotPosition.bottomCenter,
                                animationCurve: Curves.fastOutSlowIn,
                                animationDuration: Duration(milliseconds: 2000))
                            : Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                        : Stack(
                            alignment: FractionalOffset.center,
                            children: <Widget>[
                                Container(
                                  color: Colors.black,
                                ),
                                (vp == null)
                                    ? Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : vp,
                              ]),
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                  )
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
              buildLikeIcon(),
              Padding(padding: const EdgeInsets.only(right: 20.0)),
              GestureDetector(
                  child: const Icon(
                    FontAwesomeIcons.comment,
                    size: 25.0,
                  ),
                  onTap: () {
                    // goToComments(
                    //     context: context,
                    //     postId: postId,
                    //     ownerId: ownerId,
                    //     mediaUrl: mediaUrl);
                  }),
            ],
          ),
        ],
      ),
    ]));
  }
}
