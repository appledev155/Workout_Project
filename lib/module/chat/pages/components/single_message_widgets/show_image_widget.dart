import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowImageWidget extends StatelessWidget {
  final dynamic mediaAssets;
  final int mediaAssetCount;
  const ShowImageWidget(
      {super.key, required this.mediaAssets, required this.mediaAssetCount});

  @override
  Widget build(BuildContext context) {
    final String gifPath = dotenv.env['GifPath'].toString();
    return CachedNetworkImage(
        imageUrl: (mediaAssets['type'].toString().contains("video/"))
            ? (mediaAssets["result"]["video_thumbed"] != null)
                ? mediaAssets["result"]["video_thumbed"]["media_url"].toString()
                : ""
            : mediaAssets["result"]["resize_image"]["media_url"].toString(),
        height: (mediaAssetCount == 1) ? 200.0 : ScreenUtil().setHeight(129),
        width: (mediaAssetCount == 1) ? 200.0 : ScreenUtil().setWidth(129),
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.network(
              '$gifPath/assets/static/giphy.gif',
              height:
                  (mediaAssetCount == 1) ? 200.0 : ScreenUtil().setHeight(129),
              width:
                  (mediaAssetCount == 1) ? 200.0 : ScreenUtil().setHeight(129),
            ),
        errorWidget: (context, url, error) {
          return Container();
        });
  }
}
