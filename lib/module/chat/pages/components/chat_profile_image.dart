import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/app_colors.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class ChatProfileImage extends StatelessWidget {
  final String imagePath;
  final double size;
  final String userId;

  const ChatProfileImage(
      {super.key,
      required this.imagePath,
      this.size = 25.0,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.pushNamed(context, '/profile_detail_screen',
            arguments: [int.parse(userId), 'Details']);
      }),
      child: CircleAvatar(
        radius: size,
        backgroundColor: transparentColor,
        child: CachedNetworkImage(
          imageBuilder: (context, imageProvider) => Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return CircleAvatar(
              backgroundImage:
                  NetworkImage(app_instance.appConfig.staticUserImage),
            );
          },
          imageUrl: (imagePath.length > 5)
              ? imagePath.toString()
              : app_instance.appConfig.staticUserImage,
        ),
      ),
    );
  }
}
