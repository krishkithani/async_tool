import 'package:async_tool/Screens/camera_permission.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.asset('assets/images/Logo.png', fit: BoxFit.cover),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.help_outline_rounded)),
            const SizedBox(
              width: 4,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.account_circle_outlined)),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/images/WelcomeImage.png'),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Welcome to Video Interview Assessment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Metropolis'),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'In this video interview assessment, '
                  'the system will ask you some questions. '
                  'Based on the questions, you need to record your'
                  ' responses in a time-bound manner.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontFamily: 'Metropolis'),
                ),
                const SizedBox(
                  height: 170,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        }),
                    const Text('I have read and understood the guidelines')
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (isChecked) ? Colors.deepOrange : Colors.grey),
                    onPressed: () {
                      (isChecked)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const CameraPermission()))
                          : null;
                    },
                    child: const Text('Next ->'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
