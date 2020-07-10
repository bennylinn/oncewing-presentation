import 'package:OnceWing/models/feed.dart';
import 'package:OnceWing/my_flutter_app_icons.dart';
import 'package:OnceWing/screens/world/post_card.dart';
import 'package:OnceWing/services/feed_database_service.dart';
import 'package:OnceWing/shared/video_player.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamProvider.value(
        value: FeedDatabaseService().feedDatas,
        child: VideoInList(),
      ),
    );
  }
}

class VideoInList extends StatefulWidget {
  @override
  _VideoInListState createState() => _VideoInListState();
}

class _VideoInListState extends State<VideoInList> {
  @override
  Widget build(BuildContext context) {
    List<FeedData> feedList = Provider.of<List<FeedData>>(context) ?? [];
    return ListView.builder(
      itemCount: feedList.length,
      itemBuilder: (context, index) {
        FeedData post = feedList[index];
        return PostCard(
            owner: post.username,
            urls: post.mediaUrls,
            title: post.username,
            isImage: post.isImage);
      },
    );
  }
}
