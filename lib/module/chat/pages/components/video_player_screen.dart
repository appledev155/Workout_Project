import 'dart:async';
import 'dart:developer';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? message;

  const VideoPlayerScreen({super.key, this.message});

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  bool _isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isEnd = false;

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/images/uae.png');
    return WebVTTCaptionFile(
        fileContents); // For vtt files, use WebVTTCaptionFile
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      widget.message.toString(),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
    )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
        Timer.run(() {
          setState(() {
            _position = _controller.value.position;
          });
        });
        setState(() {
          _duration = _controller.value.duration;
        });
        _duration.compareTo(_position) == 0 ||
                _duration.compareTo(_position) == -1
            ? setState(() {
                _isEnd = true;
              })
            : setState(() {
                _isEnd = false;
              });
      })
      ..initialize().then((value) => {
            setState(() {
              _controller.play();
            })
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      backgroundColor: blackColor,
      body: Center(
        key: widget.key,
        child: Stack(key: widget.key, children: <Widget>[
          _controller.value.isInitialized
              ? AspectRatio(
                  key: widget.key,
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    key: widget.key,
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller, key: widget.key),
                      _ControlsOverlay(controller: _controller),
                      VideoProgressIndicator(
                        _controller,
                        key: widget.key,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                            playedColor: darkRedColor,
                            bufferedColor: primaryDark,
                            backgroundColor: lightColor),
                      ),
                    ],
                  ))
              : CircularProgressIndicator(key: widget.key)
        ]),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  const _ControlsOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Center(
                  child: CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: primaryDark,
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40.0,
                    semanticLabel: 'Play',
                  ),
                )),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
