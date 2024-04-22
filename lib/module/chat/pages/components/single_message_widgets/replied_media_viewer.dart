import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_colors.dart';
import '../video_player_screen.dart';

class RepliedMediaViewer extends StatefulWidget {
  final String? messageUserName;
  final List<dynamic> mediaList;
  const RepliedMediaViewer(
      {super.key, required this.mediaList, this.messageUserName});

  @override
  State<RepliedMediaViewer> createState() => _RepliedMediaViewerState();
}

class _RepliedMediaViewerState extends State<RepliedMediaViewer> {
  TransformationController controller = TransformationController();
  CarouselController carouselController = CarouselController();
  int currentImageCount = 1;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: widget.key,
        backgroundColor: blackColor,
        appBar: AppBar(
          backgroundColor: blackColor,
          elevation: 4.0,
          title: Text(widget.messageUserName.toString()),
          leadingWidth: 40,
          leading: InkWell(
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.arrow_back, color: lightColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: CarouselSlider(
                key: widget.key,
                carouselController: carouselController,
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(
                      () {
                        currentImageCount = index + 1;
                      },
                    );
                  },
                  height: double.infinity,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.ease,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
                items: widget.mediaList.map(
                  (e) {
                    if (e['type'] == "image/jpeg") {
                      return Center(
                        child: CachedNetworkImage(
                            imageUrl: e['result'][':original']['media_url']),
                      );
                    } else {
                      return Center(
                          child: SizedBox(
                        child: VideoPlayerScreen(
                            message: e['result'][':original']['media_url']
                                .toString()),
                      ));
                    }
                  },
                ).toList(),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              bottom: 10,
              start: MediaQuery.of(context).size.width / 2.2,
              child: (widget.mediaList.isEmpty || widget.mediaList.length == 1)
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        Text(
                          '$currentImageCount / ${widget.mediaList.length}',
                          style: TextStyle(color: lightColor, fontSize: 20.sp),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.image, color: lightColor)
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
