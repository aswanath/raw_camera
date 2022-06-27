part of 'camera_bloc.dart';

@immutable
abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraInitialized extends CameraState{
  final CameraController controller;
  CameraInitialized({required this.controller});
}

class CameraRecordState extends CameraState{
  final Status status;
  CameraRecordState({required this.status});
}

class CameraFailed extends CameraState{
  final String error;
  CameraFailed({required this.error});
}

class PlayVideoSuccess extends CameraState{
  final XFile file;
  final VideoPlayerController videoPlayerController;
  PlayVideoSuccess({required this.file,required this.videoPlayerController});
}

class PlayVideoFailure extends CameraState{
}
