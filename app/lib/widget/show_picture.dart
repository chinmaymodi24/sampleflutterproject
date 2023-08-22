import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowPicture extends StatelessWidget {
  final String? imageUrl;
  final File? fileUrl;

  const ShowPicture({Key? key, required this.imageUrl, required this.fileUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fileUrl != null
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(
              imageProvider: FileImage(
                fileUrl!,
              ),
              tightMode: true,
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(
                imageUrl!,
              ),
              tightMode: true,
            ),
          );
  }
}
