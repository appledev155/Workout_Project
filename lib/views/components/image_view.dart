import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import '../../config/app_colors.dart';
import '../../config/icons.dart';
import '../../model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final ItemModel? item;
  const ImageView({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageViewState(item: this.item);
}

class _ImageViewState extends State<ImageView> {
  ItemModel? item;
  PageController? _controller;
  int? firstPage = 0;
  int? cnt = 0;
  bool? _forwardArrow = true;
  bool? _backwardArrow = false;
  bool? _arForwardArrow = true;
  bool? _arBackwardArrow = false;

  _ImageViewState({this.item});

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: firstPage!);
  }

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
          title: Text('${cnt! + 1} / ${item!.propertyImagesArray!.length}'),
          backgroundColor: transparentColor,
          elevation: 0,
        ),
        body: Stack(children: [
          Hero(
              tag: 'animate${item!.id}',
              transitionOnUserGestures: true,
              child: Container(
                  child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained,
                    imageProvider:
                        NetworkImage(item!.propertyImagesArray![index]),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/icon/no-image.png");
                    },
                  );
                },
                itemCount: item!.propertyImagesArray!.length,
                pageController: _controller,
                onPageChanged: (int value) {
                  setState(() {
                    if (value == firstPage) {
                      _backwardArrow = false;
                    } else {
                      _backwardArrow = true;
                    }
                    if (value == item!.propertyImagesArray!.length - 1) {
                      _forwardArrow = false;
                    } else {
                      _forwardArrow = true;
                    }
                    if (value != firstPage) {
                      _arBackwardArrow = true;
                    } else {
                      _arBackwardArrow = false;
                    }
                    if (value != item!.propertyImagesArray!.length - 1) {
                      _arForwardArrow = true;
                    } else {
                      _arForwardArrow = false;
                    }
                    cnt = value;
                  });
                },
                loadingBuilder: (context, event) => Center(
                  child: Container(
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
                if (item!.propertyImagesArray!.length != 1)
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
                            if (_controller!.hasClients) {
                              _controller!.previousPage(
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
                            if (_controller!.hasClients) {
                              _controller!.nextPage(
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 200));
                            }
                          },
                        ))
                  ],
                if (item!.propertyImagesArray!.length != 1)
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
                            if (_controller!.hasClients) {
                              _controller!.previousPage(
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
                            if (_controller!.hasClients) {
                              _controller!.nextPage(
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 200));
                            }
                          },
                        ))
                  ]
              ],
            )),
          )
        ]));
  }

  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
