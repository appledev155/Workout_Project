import 'dart:convert';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/image_preview._screen.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/show_image_widget.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/download_image_bloc/download_image_bloc.dart';

class ImagesWidget extends StatelessWidget {
  final MessageRow messageRow;
  final String currentUserId;

  const ImagesWidget(
      {super.key, required this.messageRow, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    // return Text(message.message);

    int mediaAssetCount = 0;
    List mediaAssets = [];
    int moreImagesCount = 0;
    try {
      dynamic messageString = jsonDecode(messageRow.message.content!.data);
      mediaAssets = messageString['propertyImage'].runtimeType != Null ||
              messageString['propertyImage'] != ''
          ? jsonDecode(messageString['propertyImage'].toString())
          : [];
      mediaAssetCount = mediaAssets.length;
      moreImagesCount = mediaAssetCount - 4;
    } catch (e, stackTrace) {
      print('e \\n $e : stackTrace \\n $stackTrace');
      return Text(messageRow.message.toString());
    }

    return Wrap(
      key: key,
      spacing: 1.5,
      runSpacing: 1.5,
      children: [
        for (int i = 0; i < mediaAssetCount; i++) ...[
          BlocConsumer<DownloadImageBloc, DownloadImageState>(
            listener: (context, state) {},
            builder: (context, state) {
              return (mediaAssetCount == 3)
                  ? (i > 1)
                      ? const SizedBox.shrink()
                      : (i == 1)
                          ? GestureDetector(
                              key: key,
                              onTap: () {
                                context.read<DownloadImageBloc>().add(
                                    DownloadImage(imageArray: mediaAssets));
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
                                                child: ShowImageWidget(
                                                  mediaAssets: mediaAssets[i],
                                                  mediaAssetCount:
                                                      mediaAssetCount,
                                                )),
                                            (mediaAssetCount == 3)
                                                ? Text(
                                                    "+1",
                                                    style: TextStyle(
                                                        fontSize: 35.sp,
                                                        color: lightColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox.shrink()
                                          ],
                                        )
                                      : ShowImageWidget(
                                          mediaAssets: mediaAssets[i],
                                          mediaAssetCount: mediaAssetCount,
                                        )
                                ],
                              ),
                            )
                          : FittedBox(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<DownloadImageBloc>().add(
                                      DownloadImage(imageArray: mediaAssets));
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
                                  alignment: Alignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ShowImageWidget(
                                          mediaAssets: mediaAssets[i],
                                          mediaAssetCount: mediaAssetCount,
                                        ),
                                        (mediaAssets[i]['type']
                                                .toString()
                                                .contains("video/"))
                                            ? IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<DownloadImageBloc>()
                                                      .add(DownloadImage(
                                                          imageArray:
                                                              mediaAssets));
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __,
                                                                ___) =>
                                                            ImagePreviewScreen(
                                                          currentUserId:
                                                              currentUserId,
                                                          messageRow:
                                                              messageRow,
                                                        ),
                                                        transitionDuration:
                                                            const Duration(
                                                                seconds: 0),
                                                      ));
                                                },
                                                icon: Icon(
                                                  playIcon,
                                                  color: lightColor,
                                                  size: 40.sp,
                                                ),
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                  : (i > 3)
                      ? const SizedBox.shrink()
                      : (i == 3)
                          ? GestureDetector(
                              key: key,
                              onTap: () {
                                context.read<DownloadImageBloc>().add(
                                    DownloadImage(imageArray: mediaAssets));
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
                                  (mediaAssetCount > 4)
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Blur(
                                                blur: 5,
                                                blurColor: blackColor,
                                                child: ShowImageWidget(
                                                  mediaAssets: mediaAssets[i],
                                                  mediaAssetCount:
                                                      mediaAssetCount,
                                                )),
                                            (mediaAssetCount > 4)
                                                ? Text(
                                                    "+ $moreImagesCount",
                                                    style: TextStyle(
                                                        fontSize: 35.sp,
                                                        color: lightColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox.shrink()
                                          ],
                                        )
                                      : ShowImageWidget(
                                          mediaAssets: mediaAssets[i],
                                          mediaAssetCount: mediaAssetCount,
                                        )
                                ],
                              ),
                            )
                          : FittedBox(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<DownloadImageBloc>().add(
                                      DownloadImage(imageArray: mediaAssets));
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
                                  alignment: Alignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ShowImageWidget(
                                          mediaAssets: mediaAssets[i],
                                          mediaAssetCount: mediaAssetCount,
                                        ),
                                        (mediaAssets[i]['type']
                                                .toString()
                                                .contains("video/"))
                                            ? IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<DownloadImageBloc>()
                                                      .add(DownloadImage(
                                                          imageArray:
                                                              mediaAssets));
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __,
                                                                ___) =>
                                                            ImagePreviewScreen(
                                                          currentUserId:
                                                              currentUserId,
                                                          messageRow:
                                                              messageRow,
                                                        ),
                                                        transitionDuration:
                                                            const Duration(
                                                                seconds: 0),
                                                      ));
                                                },
                                                icon: Icon(
                                                  playIcon,
                                                  color: lightColor,
                                                  size: 40.sp,
                                                ),
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
            },
          )
        ],
      ],
    );
  }
}
