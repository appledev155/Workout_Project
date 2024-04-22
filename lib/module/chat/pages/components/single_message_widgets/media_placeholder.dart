import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/image_preview._screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../config/icons.dart';
import '../../../bloc/download_image_bloc/download_image_bloc.dart';

StreamSubscription<String>? _uploadProgressStream;

class MediaPlaceholder extends StatelessWidget {
  final MessageRow messageRow;
  final String currentUserId;
  const MediaPlaceholder(
      {super.key, required this.messageRow, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    Stream<dynamic> uploadStatus =
        BlocProvider.of<ChatBloc>(context).uploadStatus.stream;

    int mediaAssetCount = 0;
    List mediaAssets = [];
    int moreImagesCount = 0;
    dynamic uploadUniqueId = '';
    try {
      MessageContent messageContent = MessageContent.fromJson(
          jsonDecode(messageRow.message.content.toString()));
      dynamic messageString = messageContent.data;

      uploadUniqueId = messageString["uniqueId"];
      mediaAssets = messageString['uploadFiles'].runtimeType != Null ||
              messageString['uploadFiles'] != ''
          ? jsonDecode(messageString['uploadFiles'].toString())
          : [];
      mediaAssetCount = mediaAssets.length;
      moreImagesCount = mediaAssetCount - 4;
    } catch (e, stackTrace) {
      print('e \\n $e : stackTrace \\n $stackTrace');
      return Text(messageRow.message.toString());
    }

    return StreamBuilder<dynamic>(
        stream: uploadStatus,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.data != null && uploadUniqueId == snapshot.data) {
            _uploadProgressStream?.cancel();
          }
          return Visibility(
            visible: uploadUniqueId == snapshot.data ? false : true,
            replacement: const SizedBox.shrink(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: [
                    for (int i = 0; i < mediaAssetCount; i++) ...[
                      (mediaAssetCount == 3)
                          ? (i > 1)
                              ? const SizedBox.shrink()
                              : (i == 1)
                                  ? GestureDetector(
                                      key: key,
                                      onTap: () {
                                        context.read<DownloadImageBloc>().add(
                                            DownloadImage(
                                                imageArray: mediaAssets));
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  ImagePreviewScreen(
                                                currentUserId: currentUserId,
                                                messageRow: messageRow,
                                              ),
                                              transitionDuration:
                                                  const Duration(seconds: 0),
                                            ));
                                      },
                                      child: Stack(
                                        key: key,
                                        alignment: Alignment.center,
                                        children: [
                                          (mediaAssetCount == 3)
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Blur(
                                                      blur: 5,
                                                      blurColor: blackColor,
                                                      child: SizedBox(
                                                        height: ScreenUtil()
                                                            .setHeight(129),
                                                        width: ScreenUtil()
                                                            .setWidth(129),
                                                        child: Blur(
                                                          blur: 5,
                                                          blurColor: blackColor,
                                                          child: Image.file(
                                                              height: 200,
                                                              width: 200,
                                                              File(mediaAssets[
                                                                      i]
                                                                  .toString())),
                                                        ),
                                                      ),
                                                    ),
                                                    (mediaAssetCount == 3)
                                                        ? Text(
                                                            "+1",
                                                            style: TextStyle(
                                                                fontSize: 35.sp,
                                                                color:
                                                                    lightColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : const SizedBox
                                                            .shrink()
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: ScreenUtil()
                                                      .setHeight(129),
                                                  width: ScreenUtil()
                                                      .setWidth(129),
                                                  child: Blur(
                                                    blur: 5,
                                                    blurColor: blackColor,
                                                    child: Image.file(
                                                        height: 200,
                                                        width: 200,
                                                        File(mediaAssets[i]
                                                            .toString())),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                                  : FittedBox(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    ImagePreviewScreen(
                                                  currentUserId: currentUserId,
                                                  messageRow: messageRow,
                                                  isComeFromLocal: true,
                                                  localImagesList: mediaAssets,
                                                ),
                                                transitionDuration:
                                                    const Duration(seconds: 0),
                                              ));
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  (p.extension(mediaAssets[i]
                                                              .toString()) !=
                                                          ".mp4")
                                                      ? SizedBox(
                                                          height:
                                                              (mediaAssetCount >
                                                                      1)
                                                                  ? ScreenUtil()
                                                                      .setHeight(
                                                                          129)
                                                                  : 200,
                                                          width:
                                                              (mediaAssetCount >
                                                                      1)
                                                                  ? ScreenUtil()
                                                                      .setWidth(
                                                                          129)
                                                                  : 200,
                                                          child: Image.file(
                                                              height: 200,
                                                              width: 200,
                                                              fit: BoxFit.cover,
                                                              File(
                                                                mediaAssets[i]
                                                                    .toString(),
                                                              )))
                                                      : videoPlaceholder(
                                                          mediaAssetCount,
                                                          mediaAssets[i]
                                                              .toString())
                                                ])
                                          ],
                                        ),
                                      ),
                                    )
                          : (i >= 4)
                              ? const SizedBox.shrink()
                              : (i == 3)
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  ImagePreviewScreen(
                                                currentUserId: currentUserId,
                                                messageRow: messageRow,
                                                isComeFromLocal: true,
                                                localImagesList: mediaAssets,
                                              ),
                                              transitionDuration:
                                                  const Duration(seconds: 0),
                                            ));
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          (mediaAssetCount > 4)
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: ScreenUtil()
                                                          .setHeight(129),
                                                      width: ScreenUtil()
                                                          .setWidth(129),
                                                      child: Blur(
                                                        blur: 5,
                                                        blurColor: blackColor,
                                                        child: Image.file(
                                                            height: 200,
                                                            width: 200,
                                                            File(mediaAssets[i]
                                                                .toString())),
                                                      ),
                                                    ),
                                                    (mediaAssetCount > 4)
                                                        ? Text(
                                                            "+ $moreImagesCount",
                                                            style: TextStyle(
                                                                fontSize: 35.sp,
                                                                color:
                                                                    lightColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : const SizedBox
                                                            .shrink()
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: ScreenUtil()
                                                      .setHeight(129),
                                                  width: ScreenUtil()
                                                      .setWidth(129),
                                                  child: ((p.extension(
                                                              mediaAssets[i]
                                                                  .toString()) ==
                                                          ".mp4"))
                                                      ? videoPlaceholder(
                                                          mediaAssetCount,
                                                          mediaAssets[i]
                                                              .toString())
                                                      : Image.file(
                                                          height: 200,
                                                          width: 200,
                                                          fit: BoxFit.cover,
                                                          File(mediaAssets[i]
                                                              .toString()))),
                                        ],
                                      ),
                                    )
                                  : FittedBox(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    ImagePreviewScreen(
                                                  currentUserId: currentUserId,
                                                  messageRow: messageRow,
                                                  isComeFromLocal: true,
                                                  localImagesList: mediaAssets,
                                                ),
                                                transitionDuration:
                                                    const Duration(seconds: 0),
                                              ));
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  (p.extension(mediaAssets[i]
                                                              .toString()) !=
                                                          ".mp4")
                                                      ? SizedBox(
                                                          height:
                                                              (mediaAssetCount >
                                                                      1)
                                                                  ? ScreenUtil()
                                                                      .setHeight(
                                                                          129)
                                                                  : 200,
                                                          width:
                                                              (mediaAssetCount >
                                                                      1)
                                                                  ? ScreenUtil()
                                                                      .setWidth(
                                                                          129)
                                                                  : 200,
                                                          child: Image.file(
                                                              height: 200,
                                                              width: 200,
                                                              fit: BoxFit.cover,
                                                              File(
                                                                mediaAssets[i]
                                                                    .toString(),
                                                              )))
                                                      : videoPlaceholder(
                                                          mediaAssetCount,
                                                          mediaAssets[i]
                                                              .toString())
                                                ])
                                          ],
                                        ),
                                      ),
                                    )
                    ],
                  ],
                ),
                LoadingAnimationWidget.discreteCircle(
                    key: key,
                    color: lightColor,
                    size: 30,
                    secondRingColor: primaryDark,
                    thirdRingColor: redColor)
              ],
            ),
          );
        });
  }

  Widget videoPlaceholder(dynamic mediaAssetCount, dynamic videopath) {
    return FutureBuilder<File>(
        future: genThumbnailFile(videopath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              child: Stack(
                key: key,
                alignment: Alignment.center,
                children: [
                  Image.file(
                    fit: BoxFit.cover,
                    snapshot.data!,
                    height: (mediaAssetCount > 1)
                        ? ScreenUtil().setHeight(129)
                        : 200,
                    width: (mediaAssetCount > 1)
                        ? ScreenUtil().setWidth(129)
                        : 200,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      playIcon,
                      color: lightColor,
                      size: 40.sp,
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<File> genThumbnailFile(String path) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
    );
    File file = File(fileName!);
    return file;
  }
}
