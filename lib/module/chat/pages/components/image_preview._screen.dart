import 'dart:io';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/chat/bloc/download_image_bloc/download_image_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/components/video_player_screen.dart';
import 'package:anytimeworkout/views/components/bottom_loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:anytimeworkout/config.dart' as app_instance;
import '../../model/chat_model.dart';

class ImagePreviewScreen extends StatelessWidget {
  final MessageRow messageRow;
  final String currentUserId;
  final bool isComeFromLocal;
  final List<dynamic>? localImagesList;

  ImagePreviewScreen({
    super.key,
    required this.messageRow,
    required this.currentUserId,
    this.isComeFromLocal = false,
    this.localImagesList,
  });

  late Future<void> initializeVideoPlayerFuture;

  @override
  Widget build(BuildContext context) {
    TransformationController controller = TransformationController();
    CarouselController carouselController = CarouselController();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocConsumer<DownloadImageBloc, DownloadImageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            key: key,
            backgroundColor: blackColor,
            appBar: AppBar(
              backgroundColor: blackColor,
              elevation: 4.0,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      (messageRow.chatUser.userId == currentUserId)
                          ? "You"
                          : messageRow.chatUser.username,
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 18.sp,
                          color: lightColor,
                          fontWeight: FontWeight.bold)),
                  Text(
                    app_instance.utility.getLocalDateFromMilliseconds(
                        milliseconds: messageRow.timeStamp),
                    style: const TextStyle(
                        height: 2,
                        color: lightColor,
                        fontSize: 12,
                        letterSpacing: 1.0),
                  ),
                ],
              ),
              leadingWidth: 40,
              leading: InkWell(
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.arrow_back, color: lightColor),
                  onPressed: () {
                    context.read<DownloadImageBloc>().add(ResetImageSlider());
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            body: ((isComeFromLocal == true)
                    ? localImagesList!.isEmpty
                    : state.downloadedImageArray.isEmpty)
                ? BottomLoader()
                : Stack(
                    children: [
                      Center(
                        child: CarouselSlider(
                          key: key,
                          carouselController: carouselController,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              context.read<DownloadImageBloc>().add(
                                  ShowCurrentImageCount(
                                      currentImageCount: index + 1));
                            },
                            height: double.infinity,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.ease,
                            enlargeCenterPage: false,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: (isComeFromLocal == true)
                              ? localImagesList!.map(
                                  (i) {
                                    File downloadedFile = File(i);
                                    final extension = p.extension(i.toString());
                                    if (extension == ".mp4") {
                                      return Center(
                                          child: SizedBox(
                                        child: VideoPlayerScreen(
                                            message: i.toString()),
                                      ));
                                    } else {
                                      return Builder(
                                        key: key,
                                        builder: (BuildContext context) {
                                          return Container(
                                              child: (state.status ==
                                                          DownloadImageStatus
                                                              .success &&
                                                      downloadedFile
                                                              .runtimeType !=
                                                          Null)
                                                  ? InteractiveViewer(
                                                      key: key,
                                                      maxScale: 5.0,
                                                      minScale: 1.0,
                                                      transformationController:
                                                          controller,
                                                      onInteractionEnd:
                                                          (ScaleEndDetails
                                                              endDetails) {
                                                        controller.value =
                                                            Matrix4.identity();
                                                      },
                                                      child: Center(
                                                          child: FutureBuilder(
                                                        future: getLocalFile(
                                                            downloadedFile),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<File>
                                                                snapshot) {
                                                          return snapshot
                                                                      .data !=
                                                                  null
                                                              ? Image.file(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  downloadedFile,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  errorBuilder:
                                                                      ((context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Container(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          const Center(
                                                                        child: Text(
                                                                            'Error load image',
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      ),
                                                                    );
                                                                  }),
                                                                )
                                                              : BottomLoader();
                                                        },
                                                      )))
                                                  : BottomLoader());
                                        },
                                      );
                                    }
                                  },
                                ).toList()
                              : state.downloadedImageArray.map(
                                  (i) {
                                    File downloadedFile = File(i);
                                    final extension = p.extension(i.toString());
                                    if (extension == ".mp4") {
                                      return Center(
                                        child: SizedBox(
                                          child: VideoPlayerScreen(
                                              message: i.toString()),
                                        ),
                                      );
                                    } else {
                                      return Builder(
                                        key: key,
                                        builder: (BuildContext context) {
                                          return Container(
                                              child: (state.status ==
                                                          DownloadImageStatus
                                                              .success &&
                                                      downloadedFile
                                                              .runtimeType !=
                                                          Null)
                                                  ? InteractiveViewer(
                                                      key: key,
                                                      maxScale: 5.0,
                                                      minScale: 1.0,
                                                      transformationController:
                                                          controller,
                                                      onInteractionEnd:
                                                          (ScaleEndDetails
                                                              endDetails) {
                                                        controller.value =
                                                            Matrix4.identity();
                                                      },
                                                      child: Center(
                                                          child: FutureBuilder(
                                                        future: getLocalFile(
                                                            downloadedFile),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<File>
                                                                snapshot) {
                                                          return snapshot
                                                                      .data !=
                                                                  null
                                                              ? Image.file(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  downloadedFile,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  errorBuilder:
                                                                      ((context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Container(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          const Center(
                                                                        child: Text(
                                                                            'Error load image',
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      ),
                                                                    );
                                                                  }),
                                                                )
                                                              : BottomLoader();
                                                        },
                                                      )))
                                                  : BottomLoader());
                                        },
                                      );
                                    }
                                  },
                                ).toList(),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        bottom: 10,
                        start: MediaQuery.of(context).size.width / 2.2,
                        child: (state.downloadedImageArray.isEmpty ||
                                state.downloadedImageArray.length == 1)
                            ? const SizedBox.shrink()
                            : Text(
                                '${state.currentImageCount} / ${state.downloadedImageArray.length}',
                                style: TextStyle(
                                    color: lightColor, fontSize: 20.sp),
                              ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Future<File> getLocalFile(File? downloadedFile) async {
    File file = File(downloadedFile.toString());
    return file;
  }
}
