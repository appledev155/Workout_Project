import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/icons.dart';

class PropertyImageView extends StatefulWidget {
  final List propertyImagesArray;

  const PropertyImageView({super.key, required this.propertyImagesArray});

  @override
  State<StatefulWidget> createState() {
    return _PropertyImageViewState();
  }
}

class _PropertyImageViewState extends State<PropertyImageView> {
  final PageController _controller = PageController();
  int? firstPage = 0;
  int? cnt = 0;
  bool? _forwardArrow = true;
  bool? _backwardArrow = false;
  bool? _arForwardArrow = true;
  bool? _arBackwardArrow = false;

  @override
  Widget build(BuildContext context) {
    final String defaultLocale = Localizations.localeOf(context).toString();
    return Scaffold(
      backgroundColor: blackColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: lightColor,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: Text('${cnt! + 1} / ${widget.propertyImagesArray.length}'),
        backgroundColor: transparentColor,
        elevation: 0,
      ),
      body: Stack(children: [
        Hero(
            tag: 'animate${1}',
            transitionOnUserGestures: true,
            child: SizedBox(
                child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained,
                  imageProvider: NetworkImage(widget.propertyImagesArray[index]
                          ["result"]["resize_image"]["media_url"]
                      .toString()),
                );
              },
              itemCount: widget.propertyImagesArray.length,
              pageController: _controller,
              onPageChanged: (int value) {
                setState(() {
                  if (value == firstPage) {
                    _backwardArrow = false;
                  } else {
                    _backwardArrow = true;
                  }
                  if (value == widget.propertyImagesArray.length - 1) {
                    _forwardArrow = false;
                  } else {
                    _forwardArrow = true;
                  }
                  if (value != firstPage) {
                    _arBackwardArrow = true;
                  } else {
                    _arBackwardArrow = false;
                  }
                  if (value != widget.propertyImagesArray.length - 1) {
                    _arForwardArrow = true;
                  } else {
                    _arForwardArrow = false;
                  }
                  cnt = value;
                });
              },
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
            ))),
        Positioned(
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.propertyImagesArray.length != 1)
                if (defaultLocale == 'en_US') ...[
                  Visibility(
                      visible: _backwardArrow!,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: lightColor.withOpacity(0.6)),
                        child: const Icon(
                          backArrow,
                          color: blackColor,
                        ),
                        onPressed: () {
                          if (_controller.hasClients) {
                            _controller.previousPage(
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 200));
                          }
                        },
                      )),
                  Visibility(
                      visible: _forwardArrow!,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: lightColor.withOpacity(0.6)),
                        child: const Icon(
                          forwardArrow,
                          color: blackColor,
                        ),
                        onPressed: () {
                          if (_controller.hasClients) {
                            _controller.nextPage(
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 200));
                          }
                        },
                      ))
                ],
              if (widget.propertyImagesArray.length != 1)
                if (defaultLocale == 'ar_AR') ...[
                  Visibility(
                      visible: _arBackwardArrow!,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: lightColor.withOpacity(0.6)),
                        child: const Icon(
                          forwardArrow,
                          color: blackColor,
                        ),
                        onPressed: () {
                          if (_controller.hasClients) {
                            _controller.previousPage(
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 200));
                          }
                        },
                      )),
                  Visibility(
                      visible: _arForwardArrow!,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: lightColor.withOpacity(0.6)),
                        child: const Icon(
                          backArrow,
                          color: blackColor,
                        ),
                        onPressed: () {
                          if (_controller.hasClients) {
                            _controller.nextPage(
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 200));
                          }
                        },
                      ))
                ]
            ],
          )),
        )
      ]),
    );
  }
}
