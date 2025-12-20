import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/widgets/logo_and_text_widget.dart';

void main() {
  runApp(const MaterialApp(home: OnboardingScreen()));
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 1), () {
    //   if (mounted) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const LoginScreen()),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: const Center(
          child: LogoTextWidget(
            text: "WELCOME TO QUOCTHIEN",
            imageUrl: 'assets/images/icon1.png',
            textSize: 24,
            imgWidth: 200,
            imgHeight: 150,
          ),
        ),
      ),
    );
  }
}
