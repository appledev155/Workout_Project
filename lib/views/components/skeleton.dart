import '../../config/app_colors.dart';
import '../../config/icons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer.fromColors(
            baseColor: greyColor.withOpacity(0.1),
            highlightColor: lightColor,
            child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration:
                            BoxDecoration(border: Border.all(color: greyColor)),
                        margin: const EdgeInsets.fromLTRB(1.5, 2, 1.5, 3),
                        child: Row(
                          children: <Widget>[
                            Container(
                              color: lightColor,
                              height: 140.0,
                              width: 140.0,
                            ),
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 0, bottom: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              width: 150,
                                                              height: 20,
                                                              color:
                                                                  lightColor),
                                                          const Icon(favIcon,
                                                              color:
                                                                  lightColor),
                                                        ]),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 20,
                                                        color: lightColor),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 20,
                                                        color: lightColor),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 20,
                                                        color: lightColor),
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
                      ));
                })));
  }
}
