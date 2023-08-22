import 'dart:developer';
import 'package:flutter/material.dart';
import 'media_compressor.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart' hide LatLng;
import 'package:image_picker/image_picker.dart';

class ImagePick {
  Future<String?> getImage(BuildContext context, {required bool isCamera}) async {
    if (isCamera) {
      final imgPicker = ImagePicker();
      XFile? assets = await imgPicker.pickImage(source: ImageSource.camera);

      log("isCamera Assets name = ${assets?.name}");
      log("isCamera Assets path= ${assets?.path}");

      if(assets!=null)
      {
        var imageCompressor =
        await MediaCompressor().imageCompressor(assets.path, 15);
        String imageCompressorPath = imageCompressor.toString();
        log("path = $imageCompressorPath");
        log("imageCompressor = ${imageCompressor.toString().split("/").last}");
        return imageCompressorPath;
      }
    } else {
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
          textDelegate: EnglishAssetPickerTextDelegate(),

        ),
      );
      if(assets!=null)
      {
        final file = await assets.first.file;


        var imageCompressor =
        await MediaCompressor().imageCompressor(file!.path, 15);
        String imageCompressorPath = imageCompressor.toString();
        log("path = $imageCompressorPath");
        log("imageCompressor = ${imageCompressor.toString().split("/").last}");
        return imageCompressorPath;

        // log("Gallery Assets = ${assets.first.title}");
        // log("Gallery Assets = ${file!.path}");
        // return file.path;
      }
    }
  }
}