import 'package:OnceWing/shared/vid_player2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class VidPlayer extends StatefulWidget {
  String url;
  bool fromFile;
  FileInfo fileInfo;
  VidPlayer({this.url, this.fromFile, this.fileInfo});

  @override
  _VidPlayerState createState() => _VidPlayerState();
}

class _VidPlayerState extends State<VidPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.fromFile) {
      _controller = VideoPlayerController.file(widget.fileInfo.file)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }

    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: RaisedButton(
      //   child: Text('Test GMaps API'),
      //   onPressed: () => _pushPage(context, PlaceMarkerPage()),
      // )
      child: (_controller.value.initialized)
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayPause(_controller),
            )
          : CircularProgressIndicator(),
    );
  }
}
