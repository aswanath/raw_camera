import 'package:camera_record_app/bloc/camera_bloc.dart';
import 'package:camera_record_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraBloc>(
      create: (context) =>
      CameraBloc()
        ..add(InitializeCamera())..add(
          VideoRecordEvent(status: Status.initialize)),
      child: BlocListener<CameraBloc, CameraState>(
        listener: (context, state) {
          if(state is CameraFailed){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}
