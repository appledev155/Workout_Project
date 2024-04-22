import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/upload_progress_bloc/upload_progress_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/components/bottom_loader.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/image_preview._screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

StreamSubscription<String>? _uploadProgressStream;

class UploadProgressIndicator extends StatelessWidget {
  const UploadProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Stream<dynamic> uploadStatus =
        BlocProvider.of<UploadProgressBloc>(context).uploadStart.stream;

    bool showLoader = false;

    String currentChannelId =
        BlocProvider.of<ChatBloc>(context).state.currentChannel.channelId;

    return StreamBuilder<dynamic>(
        stream: uploadStatus,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            dynamic getStreamData = json.decode(snapshot.data);

            String uniqueId = getStreamData['uniqueId'];
            String status = getStreamData['status'];

            List getChannelId = uniqueId.split("-");
            String channelId = getChannelId[1];
            if (channelId == currentChannelId && status == 'start') {
              showLoader = true;
            } else {
              showLoader = false;
            }
          }

          return Visibility(
              visible: showLoader,
              replacement: const SizedBox.shrink(),
              child: const BottomLoader());
        });
  }
}
