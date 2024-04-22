import '../../../config/styles.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PropertyFeature extends StatelessWidget {
  final List? amenities;
  const PropertyFeature({Key? key, this.amenities})
      : assert(amenities != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: amenities!
            .map((e) => Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: greyColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    "DATABASE_VAR." + e['amenity'],
                    //  overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: greyColor,
                      fontSize: pageTextSize,
                    ),
                  ).tr(),
                )))
            .toList());
    /* ListView.builder(
      shrinkWrap: true,
      itemCount: amenities.length,
      itemBuilder: (context, index)
          /* shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 10.0),
      physics: NeverScrollableScrollPhysics(),
     // mainAxisSpacing: 3,
      //crossAxisSpacing: 3,
      crossAxisCount: 4,
      //childAspectRatio: 3.5,
      // Generate 100 widgets that display their index in the List.
      children: amenities
          .map(
            (item) */
          =>
          Container(decoration: BoxDecoration(border: Border.all(color: greyColor),borderRadius: BorderRadius.all(Radius.circular(10)) ),child: Text(
        "DATABASE_VAR." + amenities[index]['amenity'],
        //  overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: greyColor,
          fontSize: 13,
        ),
      ).tr(),)
    ); */
  }
}
