import 'package:camera/camera.dart';
import 'package:camera_record_app/bloc/camera_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatelessWidget {
  final XFile xFile;
  final VideoPlayerController videoPlayerController;

  const PlayVideo(
      {Key? key, required this.xFile, required this.videoPlayerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    videoPlayerController.initialize().then((value) => videoPlayerController.play());
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Text("Latest Video"),
          AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          ),
        ],
      ),
    ));
  }
}
