import 'package:anytimeworkout/config/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class UserImage extends StatelessWidget {
  final ChatUser? chatUser;
  const UserImage({super.key, this.chatUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: blackColor,
          width: 1,
        ),
        boxShadow:const [
          BoxShadow(
              color: greyColor,
              offset: const Offset(0, 2),
              blurRadius: 3)
        ],
        // Colors.grey.withOpacity(.3)
      ),
      child: GestureDetector(
        onTap: () {
          if (chatUser == ChatUser.empty ||
              chatUser!.userId.toString() == '0') {
            Navigator.pushNamed(context, '/login');
          } else {
            Navigator.pushNamed(context, '/profile_detail_screen',
                arguments: [int.parse(chatUser!.userId), 'Details']);
          }
        },
        child: CachedNetworkImage(
          imageBuilder: (context, imageProvider) => Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return const CircleAvatar(
              backgroundColor: lightColor,
              backgroundImage: AssetImage("assets/icon/giphy.gif"),
            );
          },
          imageUrl: (chatUser!.userImage.length > 5)
              ? chatUser!.userImage.toString()
              : app_instance.appConfig.staticUserImage,
        ),
      ),
    );
  }
}
