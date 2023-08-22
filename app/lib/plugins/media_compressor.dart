import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MediaCompressor {
  Future<String> imageCompressor(String path, int isMoreCompress) async {
    File file = File(path);
    int bytes = file.lengthSync();
    double lengthMB = bytes / (1024 * 1024);

    if (lengthMB < 0.3) {
      return path;
    }
    // print("length - >$lengthMB");

    int compressQuality = getCompressQuality(lengthMB);

    final tmpDir = (await getTemporaryDirectory()).path;
    final target =
        "$tmpDir/${DateTime.now().millisecondsSinceEpoch}-$compressQuality.${getFileExtension(path)}";

    var result = await FlutterImageCompress.compressAndGetFile(
      path,
      target,
      quality: compressQuality - isMoreCompress,
      rotate: 0,
    );
    // int bytest =   result!.lengthSync();
    // double lengthMBt = bytest / (1024*1024);
    // print("length - >$lengthMBt");
    return result!.path;
  }

  getFileExtension(String path) {
    return path.split("/").last.split(".").last;
  }

  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }

  int getCompressQuality(
      double fileSize,
      ) {
    if (fileSize > 10) {
      return 30;
    } else if (fileSize > 6) {
      return 40;
    } else if (fileSize > 3) {
      return 50;
    } else if (fileSize > 1) {
      return 60;
    } else if ((fileSize / 2) > 0.5) {
      return 70;
    } else {
      return 88;
    }
  }

  /*Future<File?> videoCompressor(String path) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    return mediaInfo?.file;
  }*/

  /*Future<File?> getVideoThumbNail(String path) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(path,
        quality: 50, // default(100)
        position: -1 // default(-1)
    );
    return thumbnailFile;
  }*/
}
