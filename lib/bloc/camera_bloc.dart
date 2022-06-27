import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:camera_record_app/main.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController controller =
      CameraController(camera[0], ResolutionPreset.max);
  late VideoPlayerController videoPlayerController;
  XFile? videoFile;

  CameraBloc() : super(CameraInitial()) {
    on<InitializeCamera>((event, emit) async {
      try {
        await controller.initialize();
        emit(CameraInitialized(controller: controller));
      } catch (e) {
        if (e is CameraException) {
          emit(CameraFailed(error: e.code));
        }
      }
    });

    on<VideoRecordEvent>((event, emit) async{
      if(event.status == Status.start) {
        await controller.startVideoRecording();
        emit(CameraRecordState(status: Status.start));
      }else if(event.status == Status.stop){
        videoFile = await controller.stopVideoRecording();
        emit(CameraRecordState(status: Status.stop));
      }else if(event.status == Status.pause){
        await controller.pauseVideoRecording();
        emit(CameraRecordState(status: Status.pause));
      }else if(event.status == Status.resume){
        await controller.resumeVideoRecording();
        emit(CameraRecordState(status: Status.resume));
      }else if(event.status == Status.initialize){
        emit(CameraRecordState(status: Status.initialize));
      }
    });

    on<PlayVideoEvent>((event, emit) {
        if(videoFile==null){
          emit(PlayVideoFailure());
        }else{
          videoPlayerController =  VideoPlayerController.file(File(videoFile!.path));
          emit(PlayVideoSuccess(file: videoFile!,videoPlayerController: videoPlayerController));
        }
    });

  }


  @override
  Future<void> close() async {
    controller.dispose();
    super.close();
  }
}
