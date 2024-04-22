/* import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PropertyAgency extends StatelessWidget {
  final String dbType;
  final String roleId;
  final String agencyImage;
  final String agencyName;
  final String agencyAddress;
  final String propertyAddedBy;

  PropertyAgency({
    Key key,
    this.dbType,
    this.roleId,
    this.agencyImage,
    this.agencyName,
    this.agencyAddress,
    this.propertyAddedBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'propertyDetails.lbl_property_addedby',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ).tr(),
        SizedBox(height: 15),
        Center(
            child: Column(children: [
          if (agencyImage.isNotEmpty)
            ClipRRect(
              child: Image.network(
                agencyImage,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          SizedBox(height: 10),
          Text(
            this.agencyName,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          /* SizedBox(height: 5),
          if (this.agencyAddress != null) ...[
            Text(
              this.agencyAddress,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ], */
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'propertyDetails.lbl_property_agent',
              style: TextStyle(
                fontSize: 16,
                color: greyColor,
              ),
            ).tr(),
            SizedBox(width: 2),
            Text(
              ':',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(width: 2),
            Text(
              this.propertyAddedBy,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ])
        ])),
      ],
    );
  }
}
 */

import 'package:anytimeworkout/config/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PropertyAgency extends StatelessWidget {
  final String? dbType;
  final String? roleId;
  final String? agencyImage;
  final String? agencyNameEn, agencyNameAr;
  final String? agencyAddress;
  final String? propertyAddedBy;

  const PropertyAgency({
    Key? key,
    this.dbType,
    this.roleId,
    this.agencyImage,
    this.agencyNameEn,
    this.agencyNameAr,
    this.agencyAddress,
    this.propertyAddedBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String gifPath = dotenv.env['GifPath'].toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'propertyDetails.lbl_property_addedby',
          style: TextStyle(
            fontSize: pageTitleSize * 1.2,
            fontWeight: FontWeight.w500,
          ),
        ).tr(),
        const SizedBox(height: 15),
        Center(
            child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: (agencyImage != null || agencyImage != "")
                ? CachedNetworkImage(
                    imageUrl: agencyImage!,
                    height: 100 * unitWidth,
                    width: 100 * unitWidth,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.network(
                      '$gifPath/assets/static/giphy.gif',
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.network(
                      '$gifPath/assets/static/user.png',
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.network(
                    '$gifPath/assets/static/user.png',
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            this.propertyAddedBy!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          /* SizedBox(height: 5),
          if (this.agencyAddress != null) ...[
            Text(
              this.agencyAddress,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ], */
          const SizedBox(height: 5),
          Text(
            (context.locale.toString() == 'en_US')
                ? (this.agencyNameEn!.isNotEmpty)
                    ? this.agencyNameEn!
                    : this.agencyNameAr!
                : (this.agencyNameAr!.isNotEmpty)
                    ? this.agencyNameAr!
                    : this.agencyNameEn!,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          /* Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'propertyDetails.lbl_property_agent',
              style: TextStyle(
                fontSize: 16,
                color: greyColor,
              ),
            ).tr(),
            SizedBox(width: 2),
            Text(
              ':',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(width: 2),
            
          ]) */
        ])),
      ],
    );
  }
}
