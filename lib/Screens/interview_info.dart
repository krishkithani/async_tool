import 'package:flutter/material.dart';

class InterviewInfoScreen extends StatelessWidget {
  const InterviewInfoScreen({super.key});

  final String title = 'Interview Title ';
  final int duration = 10;
  final int bufferTime = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: const TextStyle(color: Colors.white)),
                Text('Duration $duration mins',style: const TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    'Have you read this material? If not, please refer to this material before you join the call',style: TextStyle(color: Colors.white),),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Read Material ',
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    'Note: You must complete this interview in one sitting. This interview link will expire after $bufferTime of starting the assessment. Please complete this assessment before that. ',style: TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    'Once you click on “Start the Interview” the interview will start',
                style: TextStyle(color: Colors.white),),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange),
                    onPressed: () {},
                    child: const Text('Start the Interview ->'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
