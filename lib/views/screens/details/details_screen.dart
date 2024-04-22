import 'dart:io';

import 'package:anytimeworkout/views/components/property_row/favorite_icon.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '/config/styles.dart';
import 'package:anytimeworkout/views/components/property_row/rent_frequency.dart';
import 'package:share_plus/share_plus.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../model/item_model.dart';
import '../../../views/components/image_view.dart';
import '../../../views/components/property_detail/property_about.dart';
import '../../../views/components/property_detail/property_agency.dart';
import '../../../views/components/property_detail/property_feature.dart';
import '../../../views/components/property_detail/property_overview.dart';
import '../../../views/components/property_row/location.dart';
import '../../../views/components/property_row/price.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DetailsScreen extends StatefulWidget {
  final ItemModel? item;
  final Function()? function;

  DetailsScreen({Key? key, @required this.item, this.function})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState(item: this.item!);
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  AnimationController? _colorAnimationController;
  Animation? _colorTween;
  ItemModel? item;
  DragUpdateDetails? updateHorizontalDragDetails;
  ScrollController? scrollController = ScrollController();
  DragStartDetails? startHorizontalDragDetails;
  final _s3Url = dotenv.env['S3URL'];
  _DetailsScreenState({this.item});

  _launchWhatsapp(String? phone, String? msg) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(msg!)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(msg!)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  void initState() {
    super.initState();
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: lightColor)
        .animate(_colorAnimationController!);
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Detail Screen');
  }

  @override
  void didChangeDependencies() {
    if (item!.galleryImagesArray != null) {
      for (int i = 0; i < item!.galleryImagesArray!.length; i++) {
        precacheImage(
            Image.network(item!.galleryImagesArray![i]).image, context);
      }
    }

    if (item!.propertyImagesArray != null) {
      for (int i = 0; i < item!.propertyImagesArray!.length; i++) {
        precacheImage(
            Image.network(item!.propertyImagesArray![i]).image, context);
      }
    }

    super.didChangeDependencies();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController!.animateTo(scrollInfo.metrics.pixels / 200);

      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String gifPath = dotenv.env['GifPath'].toString();
    String? rec, lblunitsqft, lblunitsqm;
    rec = ((item!.nameArabic != null || item!.nameEnglish != null)
        ? (context.locale.toString() == 'ar_AR')
            ? ((item!.nameArabic != null)
                ? item!.nameArabic
                : item!.nameEnglish)
            : ((item!.nameEnglish != null)
                ? item!.nameEnglish
                : item!.nameArabic)
        : '')!;

    lblunitsqft = 'propertyDetails.lbl_sqft'.tr();
    lblunitsqm = 'propertyDetails.lbl_sqm'.tr();
    // String propertyImage = 'https://' + _host + '/images/skyblue/pro1.jpg';
    bool shouldPop = true;

    // Image slider widget function
    Widget imageSlider(List imageArray, ItemModel item) {
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
                        builder: (context) => ImageView(
                          item: item,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: const BoxDecoration(color: lightColor),
                    child: (i != null || i != "")
                        ? CachedNetworkImage(
                            imageUrl: i,
                            height: 150.0,
                            width: 150.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.network(
                              '$gifPath/assets/static/giphy.gif',
                              height: 150.0,
                              width: 150.0,
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/icon/no-image.png"),
                          )
                        : Container(
                            child: const Text(
                                    "propertyDetails.lbl_property_loading")
                                .tr(),
                          ),
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

    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
          backgroundColor: lightColor,
          body: NotificationListener<ScrollNotification>(
              onNotification: _scrollListener,
              child: SizedBox(
                  // height: double.infinity,
                  child: Stack(children: <Widget>[
                SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      if (item!.galleryImagesArray != null &&
                          item!.galleryImagesArray!.length > 0) ...[
                        imageSlider(item!.galleryImagesArray as List, item!)
                      ] else if ((item!.propertyImagesArray != null &&
                          item!.propertyImagesArray!.length > 0)) ...[
                        imageSlider(item!.propertyImagesArray as List, item!)
                      ],
                      ((item!.propertyImagesArray != null &&
                              item!.propertyImagesArray!.length > 0))
                          ? const SizedBox(height: 20)
                          : const SizedBox(height: 80),
                      Container(
                        // height: 56 + MediaQuery.of(context).padding.top,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(children: [
                              Text(rec,
                                  style: TextStyle(
                                    fontSize: pageTitleSize * 1.2,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Location(
                              location: item!.location!,
                              locationAr: item!.locationAr!,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${item!.areaSqm} $lblunitsqm',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(' | '),
                                const SizedBox(width: 5),
                                Text(
                                  '${item!.areaSqft} $lblunitsqft',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Price(price: item!.price!),
                              const SizedBox(
                                width: 5,
                              ),
                              if (item!.purpose != 'Sell')
                                Transform.translate(
                                  offset: const Offset(0, 4),
                                  child: RentFrequency(
                                    rentFreq: (item!.priceType != null)
                                        ? item!.priceType!
                                        : '',
                                  ),
                                ),
                            ]),
                            const SizedBox(height: 10),
                            const Divider(
                              color: greyColor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'propertyDetails.lbl_overview',
                              style: TextStyle(
                                fontSize: pageTitleSize * 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ).tr(),
                            const SizedBox(
                              height: 5,
                            ),
                            PropertyOverview(
                                type: item!.type!,
                                propertyType: item!.propertyType!,
                                price: item!.price!,
                                bedrooms: item!.bedrooms!,
                                toilet: item!.toilet!,
                                propertyStatus: item!.propertyStatus!,
                                purpose: item!.purpose!,
                                buildYear: item!.buildYear!),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              color: greyColor,
                            ),
                            const SizedBox(height: 5),
                            PropertyAbout(
                                descriptionArebic:
                                    (item!.descriptionArebic.toString() !=
                                            'null')
                                        ? item!.descriptionArebic!
                                        : '',
                                descriptionEnglish:
                                    (item!.descriptionEnglish.toString() !=
                                            'null')
                                        ? item!.descriptionEnglish!
                                        : ''),
                            const SizedBox(height: 15),
                            if (item!.amenities!.length > 0) ...[
                              const Divider(
                                color: greyColor,
                              ),
                              Text(
                                'filter.lbl_features_amenities',
                                style: TextStyle(
                                  fontSize: pageTitleSize * 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).tr(),
                              const SizedBox(
                                height: 10,
                              ),
                              PropertyFeature(amenities: item!.amenities!),
                            ],
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              color: greyColor,
                            ),
                            GestureDetector(
                              onTap: () => Future.delayed(Duration.zero, () {
                                Navigator.pushNamed(
                                    context, '/profile_detail_screen',
                                    arguments: [item!.userId, 'Details']);
                              }),
                              child: PropertyAgency(
                                dbType: item!.dbType!,
                                roleId: item!.roleId!,
                                agencyImage: item!.agencyImage.toString(),
                                agencyNameEn: item!.agencyName.toString(),
                                agencyNameAr: item!.agencyNameAr ?? '',
                                agencyAddress: item!.agencyAddress.toString(),
                                propertyAddedBy:
                                    (item!.propertyAddedBy.runtimeType != Null)
                                        ? item!.propertyAddedBy.toString()
                                        : 'User-${item!.userId}',
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    height: 56 + MediaQuery.of(context).padding.top,
                    child: AnimatedBuilder(
                        animation: _colorAnimationController!,
                        builder: (context, child) => AppBar(
                              titleSpacing: 0,
                              systemOverlayStyle: const SystemUiOverlayStyle(
                                  statusBarColor: lightColor,
                                  statusBarIconBrightness: Brightness.dark),
                              backgroundColor: _colorTween!.value,
                              elevation:
                                  (scrollController!.position.pixels > 200)
                                      ? 1
                                      : 0,
                              leading: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: CircleAvatar(
                                    backgroundColor: lightColor,
                                    child: IconButton(
                                        icon: Icon(
                                          (context.locale.toString() == "en_US")
                                              ? (Platform.isIOS)
                                                  ? iosBackButton
                                                  : backArrow
                                              : (context.locale.toString() ==
                                                      "ar_AR")
                                                  ? (Platform.isIOS)
                                                      ? iosForwardButton
                                                      : forwardArrow
                                                  : iosForwardButton,
                                          color: blackColor,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  )),
                              actions: [
                                Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: CircleAvatar(
                                      backgroundColor: lightColor,
                                      child: FavoriteIcon(
                                        item: item!,
                                        showOnList: 'detail',
                                        notifyParent: widget.function!,
                                        notifyFavorite: () {},
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: CircleAvatar(
                                      backgroundColor: lightColor,
                                      child: IconButton(
                                        icon: const Icon(
                                          shareIcon,
                                          color: blackColor,
                                        ),
                                        onPressed: () {
                                          Share.share(
                                              '$rec \n https://${dotenv.env['WEBSITE_HOST']}/' +
                                                  item!.slug! +
                                                  '.html',
                                              sharePositionOrigin:
                                                  Rect.fromLTWH(
                                                      0,
                                                      0,
                                                      size.width,
                                                      size.height / 2));
                                        },
                                      ),
                                    ))
                              ],
                            )))
              ]))),
          bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Container(
                            height: 35 * unitWidth,
                            width: deviceWidth,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () =>
                                  launch("tel:${item!.userPhoneNumber}"),
                              icon: Icon(contactUsIcon,
                                  color: lightColor, size: pageIconSize),
                              label: Text(
                                'propertyDetails.lbl_property_callnow',
                                style: TextStyle(
                                    color: lightColor, fontSize: pageIconSize),
                              ).tr(),
                            ))),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Container(
                            height: 35 * unitWidth,
                            width: deviceWidth,
                            child: ElevatedButton.icon(
                              onPressed: () => _launchWhatsapp(
                                  item!.userPhoneNumber!, 'Hello'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(color: primaryDark)),
                              ),
                              icon: Icon(
                                wpIcon,
                                color: primaryDark,
                                size: pageIconSize,
                              ),
                              label: Text(
                                'propertyDetails.lbl_property_WhatsApp',
                                style: TextStyle(
                                    color: primaryDark, fontSize: pageIconSize),
                              ).tr(),
                            )))
                  ]))),
    );
  }
}
