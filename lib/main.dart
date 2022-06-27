import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'app.dart';
late List<CameraDescription> camera;
late double width;
late double height;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   camera = await availableCameras();
  runApp(const MyApp());
}
