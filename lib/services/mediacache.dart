import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerr {
  Future<FileInfo> getFromCache(url) async {
    FileInfo fileInfo = await DefaultCacheManager().getFileFromCache(url);
    return fileInfo;
  }

  Future<FileInfo> getFileInfo(url) async {
    FileInfo fileInfo;

    await getFromCache(url).then((value) async {
      if (value == null) {
        print('getting from network...');
        await DefaultCacheManager()
            .downloadFile(url)
            .then((value) => fileInfo = value);
      } else {
        print('retreived from cache...');
        fileInfo = value;
      }
    });

    return fileInfo;
  }
}
