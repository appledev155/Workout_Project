import 'package:anytimeworkout/module/chat/pages/components/property_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/icons.dart';

class ImageSliderScreen extends StatelessWidget {
  final List imageArray;
  const ImageSliderScreen({super.key, required this.imageArray});

  @override
  Widget build(BuildContext context) {
    final String gifPath = dotenv.env['GifPath'].toString();
    return Stack(children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 300,
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
        ),
        items: imageArray.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PropertyImageView(propertyImagesArray: imageArray)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: const BoxDecoration(color: lightColor),
                  child: (i != null || i != "")
                      ? CachedNetworkImage(
                          key: key,
                          imageUrl: i["result"]["resize_image"]["media_url"],
                          height: 150.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.network(
                            gifPath + '/assets/static/giphy.gif',
                            height: 150.0,
                            width: 150.0,
                          ),
                          errorWidget: (context, url, error) => Container(),
                        )
                      : const Text("chat_section.lbl_loading").tr(),
                ),
              );
            },
          );
        }).toList(),
      ),
      Positioned.directional(
          textDirection: Directionality.of(context),
          bottom: 5,
          start: 5,
          child: Container(
              // height: 100,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: blackColor.withOpacity(0.6)),
              child: Row(
                children: [
                  const Icon(
                    galleryIcon,
                    color: lightColor,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    imageArray.length.toString(),
                    style: const TextStyle(color: lightColor),
                  )
                ],
              )))
    ]);
  }
}
