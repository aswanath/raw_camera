import 'package:camera/camera.dart';
import 'package:camera_record_app/bloc/camera_bloc.dart';
import 'package:camera_record_app/main.dart';
import 'package:camera_record_app/video_play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  late CameraController _cameraController;

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: BlocListener<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is PlayVideoSuccess) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlayVideo(
                          xFile: state.file,
                        videoPlayerController: state.videoPlayerController,
                        )));
          }else if(state is PlayVideoFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No video found")));
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder<CameraBloc, CameraState>(
                buildWhen: (prev, curr) {
                  if (curr is CameraInitialized) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is CameraInitialized) {
                    _cameraController = state.controller;
                    return CameraPreview(
                      _cameraController,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * .05,
                  ),
                  IconButton(
                      onPressed: () {
                        context.read<CameraBloc>().add(PlayVideoEvent());
                      },
                      icon: const Icon(
                        Icons.image,
                        size: 42,
                      )),
                  SizedBox(
                    width: width * .25,
                  ),
                  BlocBuilder<CameraBloc, CameraState>(
                    buildWhen: (prev, curr) {
                      if (curr is CameraRecordState &&
                          (curr.status == Status.start ||
                              curr.status == Status.stop ||
                              curr.status == Status.initialize)) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is CameraRecordState) {
                        if (state.status == Status.start) {
                          return ElevatedButton(
                            onPressed: () {
                              context
                                  .read<CameraBloc>()
                                  .add(VideoRecordEvent(status: Status.stop));
                            },
                            child: const Icon(Icons.stop),
                          );
                        } else if (state.status == Status.stop ||
                            state.status == Status.initialize) {
                          return ElevatedButton(
                            onPressed: () {
                              context
                                  .read<CameraBloc>()
                                  .add(VideoRecordEvent(status: Status.start));
                            },
                            child: const Icon(Icons.circle),
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  SizedBox(
                    width: width * .2,
                  ),
                  BlocBuilder<CameraBloc, CameraState>(
                    buildWhen: (prev, curr) {
                      if (curr is CameraRecordState) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is CameraRecordState) {
                        if (state.status == Status.resume ||
                            state.status == Status.start) {
                          return ElevatedButton(
                            onPressed: () {
                              context
                                  .read<CameraBloc>()
                                  .add(VideoRecordEvent(status: Status.pause));
                            },
                            child: const Icon(
                              Icons.pause,
                              color: Colors.black,
                            ),
                          );
                        } else if (state.status == Status.pause) {
                          return ElevatedButton(
                            onPressed: () {
                              context
                                  .read<CameraBloc>()
                                  .add(VideoRecordEvent(status: Status.resume));
                            },
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Interface extends StatelessWidget {
  const _Interface({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [],
    );
  }
}

// class CameraApp extends StatefulWidget {
//   /// Default Constructor
//   const CameraApp({Key? key}) : super(key: key);
//
//   @override
//   State<CameraApp> createState() => _CameraAppState();
// }
//
// class _CameraAppState extends State<CameraApp> {
//   late CameraController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(camera[0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             print('User denied camera access.');
//             break;
//           default:
//             print('Handle other errors.');
//             break;
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: CameraPreview(
//         controller,
//         child: Column(
//           children: [
//             ElevatedButton(onPressed: () {}, child: Icon(Icons.add)),
//           ],
//         ),
//       ),
//     );
//   }
// }
