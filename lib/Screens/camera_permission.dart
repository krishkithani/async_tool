import 'dart:async';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:async_tool/Overlays/permission_denied_overlay.dart';
import 'package:async_tool/Providers/permission_provider.dart';
import 'package:async_tool/Screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class CameraPermission extends ConsumerStatefulWidget {
  const CameraPermission({super.key});

  @override
  ConsumerState<CameraPermission> createState() => _CameraPermissionState();
}

class _CameraPermissionState extends ConsumerState<CameraPermission> {
  int count = 10;

  late bool isRecording;

  late XFile? recordedVideo;

  CameraController? _cameraController;

  bool isGranted = true;

  late List<CameraDescription> cameras;

  late final AppLifecycleListener _listener;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    isRecording = false;
    recordedVideo = null;
    initializeCamera();

   //
     _listener = AppLifecycleListener(onStateChange: _onStateChanged);

    //availableCameras().then((cameras) {
    //   if (cameras.isEmpty) {
    //     throw Exception();
    //     return;
    //   }
    //   CameraDescription? frontCamera = cameras.firstWhereOrNull((description) =>
    //       description.lensDirection == CameraLensDirection.front);
    //   if (frontCamera == null) {
    //     throw Exception('Front Cam');
    //     return;
    //   }
    //   _cameraController = CameraController(frontCamera, ResolutionPreset.max);
    //   _cameraController!.initialize().then((_) {
    //     if (!mounted) {
    //       return;
    //     }
    //     setState(() {});
    //   }).catchError((e) {
    //     if (e is CameraException) {
    //       switch (e.code) {
    //         case 'CameraAccessDenied':
    //           ref.watch(permissionProvider.notifier).update((state) => false);
    //           print('Denied');
    //           break;
    //         case 'AudioAccessDenied':
    //           ref.watch(permissionProvider.notifier).update((state) => false);
    //           break;
    //         default:
    //           print(e);
    //           break;
    //       }
    //     }
    //   })
    //   ;
    // }).catchError((e) {});
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print(count);
      if (count > 0) {
        setState(() {
          count--;
        });
      } else {
        timer.cancel();
      }
      if (count == 0) {
        stopRecording();
      }
    });
  }

  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        disposeCamera();
        print('##########');
      case AppLifecycleState.resumed:
        onResumed();
        print('@@@@@@@');

      default:
        print(
            '------------------------------------------------------Default $state');
    }
  }

  // void onPaused() {
  //   _cameraController?.dispose();
  //   print(
  //       '-----------------------------------------------------------------------------------------Camera Closed');
  // }

  void onResumed() async {
    if (_cameraController == null &&
            await Permission.camera.status.isGranted &&
            await Permission.microphone.status.isGranted ||
        !_cameraController!.value.isRecordingVideo) {
      initializeCamera();
    }
    print(
        '=================================Value after resume $_cameraController');

    print(
        '-----------------------------------------------------------------------------------------Camera Started');
  }

  void disposeCamera() async {
    isRecording = false;
    timer?.cancel();
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isRecordingVideo) {
      await _cameraController?.stopVideoRecording();
    }
    await _cameraController?.dispose();
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${_cameraController!}');
    _cameraController = null;
    if (mounted) {
      setState(() {});
    }
    print(
        '=================================Value after dispose $_cameraController');
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras');
      }
      CameraDescription? frontCamera = cameras.firstWhereOrNull((description) =>
          description.lensDirection == CameraLensDirection.front);
      if (frontCamera == null) {
        throw Exception('Front Cam');
        return;
      }
      _cameraController = CameraController(frontCamera, ResolutionPreset.max);
      await _cameraController!.initialize();
      ref.watch(permissionProvider.notifier).update((state) => true);
      if (!mounted) {
        return;
      }
      setState(() {});
      print(
          '=================================Value after initialize $_cameraController');
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            ref.watch(permissionProvider.notifier).update((state) => false);
            print('Denied');
            break;
          case 'AudioAccessDenied':
            ref.watch(permissionProvider.notifier).update((state) => false);
            break;
          default:
            print(e);
            break;
        }
      } else if (e is Exception) {}
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(' Buid Callleedd================================================');
    isGranted = ref.watch(permissionProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test your camera & microphone',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  'Speak this phrase out loud while recording the practice video: “Two blue fish swam in the tank”.',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        width: double.infinity,
                        child: (_cameraController != null &&
                                _cameraController!.value.isInitialized)
                            ? CameraPreview(_cameraController!)
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      (isRecording)
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/Rec_logo.png'),
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.all(10),
                                        child: const Text('Rec'),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.all(10),
                                      child: Text('00:' '$count'))
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                (isRecording)
                    ? SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          onPressed: () {
                            stopRecording();
                          },
                          child: const Text('Stop Recording'),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange),
                          onPressed: () {
                            startRecording();
                          },
                          child: const Text('Start Recording'),
                        ),
                      ),
              ],
            ),
            (isGranted)
                ? const SizedBox.shrink()
                : const PermissionDeniedOverlay(),
          ],
        ),
      ),
    );
  }

  // void onRecordingCompleted(XFile videoFile) {
  //   setState(() {
  //     recordedVideo = videoFile;
  //   });
  //   print('Recording completed. File saved at: ${recordedVideo?.path}');
  // }

  void startRecording() async {
    count = 10;
    if (_cameraController == null && !_cameraController!.value.isInitialized) {
      print('CameraController is Null or not initialized');
      return;
    }

    if (_cameraController!.value.isRecordingVideo) {
      return;
    }
    // _cameraController!.buildPreview();
    // _cameraController!.pausePreview();

    try {
      await _cameraController?.startVideoRecording();
      startTimer();
      setState(() {
        isRecording = true;
      });
      print(
          '========================Value of the controller: $_cameraController');
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  void stopRecording() async {
    if (_cameraController == null &&
        !_cameraController!.value.isInitialized &&
        !_cameraController!.value.isRecordingVideo) {
      print('Video recording error ');
      return;
    }
    timer?.cancel();
    try {
      XFile? videoFile = await _cameraController?.stopVideoRecording();

      //onRecordingCompleted(videoFile);}
      setState(() {
        recordedVideo = videoFile;
        count = 10;
        isRecording = false;
      });
      if (!mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            recordedVideo: recordedVideo?.path,
          ),
        ),
      );
      disposeCamera();
      print('Recording completed. File saved at: ${recordedVideo?.path}');
    } catch (e) {
      log('Error stopping recording:', error: e);
    }
  }
}
