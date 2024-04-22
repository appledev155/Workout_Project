import '../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDetailsSkeleton extends StatelessWidget {
  const ProfileDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: lightColor,
        highlightColor: backgroundColor,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: greyColor)),
                margin: const EdgeInsets.fromLTRB(5, 2, 5, 3),
                child: Row(
                  children: <Widget>[
                    Container(
                      color: lightColor,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
