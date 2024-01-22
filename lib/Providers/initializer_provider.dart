


import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<CameraDescription>> cameras =availableCameras();

CameraController? _cameraController;

final isInitializedProvider = FutureProvider<bool?>((ref) {
   _cameraController!.initialize().then((value) => true);
}
);