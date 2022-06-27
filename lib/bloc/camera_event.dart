part of 'camera_bloc.dart';

enum Status{initialize,start, pause , resume, stop}

@immutable
abstract class CameraEvent {}

class InitializeCamera extends CameraEvent{}

class VideoRecordEvent extends CameraEvent{
  final Status status;
  VideoRecordEvent({required this.status});
}

class PlayVideoEvent extends CameraEvent{}

