import 'dart:convert';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/replied_media_viewer.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/app_colors.dart';
import '../../../../../config/icons.dart';

class RepliedImagesPreview extends StatefulWidget {
  final String? messageUserName;
  final dynamic decodedImages;
  const RepliedImagesPreview(
      {super.key, this.decodedImages, this.messageUserName});

  @override
  State<RepliedImagesPreview> createState() => _RepliedImagesPreviewState();
}

class _RepliedImagesPreviewState extends State<RepliedImagesPreview> {
  @override
  Widget build(BuildContext context) {
    // TO DO: You send the image object only.
    dynamic decodeImagesList =
        jsonDecode(widget.decodedImages).containsKey('propertyImage')
            ? jsonDecode(jsonDecode(widget.decodedImages)['propertyImage'])
            : jsonDecode(widget.decodedImages);
    int mediaAssetCount = decodeImagesList.length;

    // log(decodeImagesList.toString());

    return GestureDetector(
      onTap: () {
        // To Do
      },
      child: Wrap(
        children: [
          for (var i = 0; i < decodeImagesList.length; i++) ...[
            (mediaAssetCount > 4)
                ? (i > 3)
                    ? const SizedBox.shrink()
                    : (i == 3)
                        ? GestureDetector(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                (mediaAssetCount > 4)
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Blur(
                                            alignment: Alignment.center,
                                            blur: 1,
                                            overlay: Text(
                                              "+ ${mediaAssetCount - 4}",
                                              style: TextStyle(
                                                  fontSize: 21.sp,
                                                  color: lightColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            blurColor: blackColor,
                                            child: displayRepliedImage(
                                                height: 55,
                                                media: decodeImagesList[i],
                                                mediaList: decodeImagesList),
                                          ),
                                        ],
                                      )
                                    : displayRepliedImage(
                                        media: decodeImagesList[i],
                                        mediaList: decodeImagesList)
                              ],
                            ),
                          )
                        : FittedBox(
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    displayRepliedImage(
                                        media: decodeImagesList[i],
                                        mediaList: decodeImagesList)
                                  ],
                                )
                              ],
                            ),
                          )
                : displayRepliedImage(
                    media: decodeImagesList[i], mediaList: decodeImagesList)
          ]
        ],
      ),
    );
  }

  // widget for show single image
  Widget displayRepliedImage(
      {required dynamic media, dynamic mediaList, double height = 60}) {
    return (media['type'] == "image/jpeg")
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RepliedMediaViewer(
                          mediaList: mediaList,
                          messageUserName: widget.messageUserName)));
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: CachedNetworkImage(
                imageUrl: media['result']['resize_image']['media_url'],
                height: height,
                width: height,
                fit: BoxFit.cover,
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RepliedMediaViewer(
                          mediaList: mediaList,
                          messageUserName: widget.messageUserName)));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: CachedNetworkImage(
                    imageUrl: (media['result']['video_thumbed'] != null)
                        ? media['result']['video_thumbed']['media_url']
                        : media['result']['resize_image']['media_url'],
                    height: height,
                    width: height,
                    fit: BoxFit.cover,
                  ),
                ),
                (media['result']['video_thumbed'] != null)
                    ? const Icon(
                        playIcon,
                        color: lightColor,
                      )
                    : const SizedBox.shrink()
              ],
            ),
          );
  }
}
