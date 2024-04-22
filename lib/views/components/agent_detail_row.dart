import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_colors.dart';

class AgentDetailRow extends StatelessWidget {
  final Map<String, dynamic> item;
  const AgentDetailRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    //  final _s3Url = dotenv.env['S3URL'];
    final String gifPath = dotenv.env['GifPath'].toString();

    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: lightColor,
        boxShadow: [
          BoxShadow(
              color: greyColor.withOpacity(0.4),
              blurRadius: 0.5,
              spreadRadius: 0.1,
              offset: const Offset(0, 0.1))
        ],
      ),
      margin: const EdgeInsets.fromLTRB(1.5, 4, 1.5, 4),
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item['image'].toString(),
            fit: BoxFit.cover,
            height: 100,
            width: 140,
            progressIndicatorBuilder: (context, url, progress) =>
                Image.network('$gifPath/assets/static/giphy.gif'),
            // errorWidget: (context, url, error) => Image.asset(
            //   'assets/images/logo.png',
            // ),
          ),
          const SizedBox(width: 15),
          Column(children: [
            Text(
              item['agentName'].toString(),
              style: TextStyle(fontSize: 20.sp),
            )
          ])
        ],
      ),
    );
  }
}
