import 'dart:io';
import 'package:async_tool/Screens/interview_info.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPreviewScreen extends StatefulWidget {
  const VideoPreviewScreen({super.key, required this.recordedVideo});

  final String? recordedVideo;
  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.recordedVideo);
    print('path======================${widget.recordedVideo}');
  }

  void _initializeVideoPlayer(recordedVideo) async {
    print('path in init===============================$recordedVideo');
    _videoPlayerController = VideoPlayerController.file(File(recordedVideo));
    await _videoPlayerController?.initialize();
    await _videoPlayerController?.play();
    await _videoPlayerController?.setVolume(100);
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: VideoPlayer(_videoPlayerController!),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Test your camera & microphone',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Play the video to check your audio & video quality. If you face any issues with your microphone/camera, then switch to a different device or contact your administrator.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'If everything is good to go, then move ahead.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const InterviewInfoScreen()));
                },
                child: const Text('Go Next ->'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
