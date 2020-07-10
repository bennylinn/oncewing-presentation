import 'dart:convert';
import 'package:http/http.dart';

enum MediaType { image, video, text }

class OnceWingStory {
  final MediaType mediaType;
  final String media;
  final double duration;
  final String caption;
  final String when;
  final String color;

  OnceWingStory({
    this.mediaType,
    this.media,
    this.duration,
    this.caption,
    this.when,
    this.color,
  });
}


/// The repository fetches the data from the same directory from git.
/// This is just to demonstrate fetching from a remote (workflow).
class Repository {
  final String url;

  Repository({
    this.url,
  });

  static MediaType _translateType(String type) {
    if (type == "image") {
      return MediaType.image;
    }

    if (type == "video") {
      return MediaType.video;
    }

    return MediaType.text;
  }

  static Future<List<OnceWingStory>> getOnceWingStories(String url) async {
    
    if (url == null){
      return [];
    } else {
      try {
        final response = await get(url);

        final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];
        
        final res = data.map<OnceWingStory>((it) {
          return OnceWingStory(
            caption: it['caption'],
            media: it['media'],
            duration: double.parse(it['duration']),
            when: it['when'],
            mediaType: _translateType(it['mediaType']),
            color: it['color']);
        }).toList();

        return res;
      } catch(e) {
        return [];
      }
    }
  }
}