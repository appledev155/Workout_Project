import '../../config/styles.dart';
import '../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RequestSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: lightColor,
        highlightColor: lightGreyColor,
        child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(1.5, 4, 1.5, 4),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 0, bottom: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            1.5, 2, 1.5, 3),
                                        padding:
                                            EdgeInsets.all(pageHPadding / 2),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: greyColor)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: 150,
                                                  height: 20,
                                                  color: lightColor),
                                              const SizedBox(height: 10),
                                              Container(
                                                  width: 150,
                                                  height: 20,
                                                  color: lightColor),
                                              const SizedBox(height: 10),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        child: Container(
                                                      width: deviceWidth,
                                                      height: 30,
                                                      decoration: const BoxDecoration(
                                                          color: lightColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                    )),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                        child: Container(
                                                      width: deviceWidth,
                                                      height: 30,
                                                      decoration: const BoxDecoration(
                                                          color: lightColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                    )),
                                                  ]),
                                            ]),
                                        //  ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
