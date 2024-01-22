import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
class PermissionDeniedOverlay extends StatelessWidget {
  const PermissionDeniedOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your camera & microphone access is blocked!',
                style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'To grant permission to access your microphone, go to App Settings ',
                style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    AppSettings.openAppSettings();
                  },
                  child: const Text('App Settings'))
            ],
          ),
        ),
      ),
    );
  }
}
