import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/widgets/logo_and_text_widget.dart';

void main() {
  runApp(MaterialApp(home: OnboardingScreen()));
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: LogoTextWidget(
          text: "WELCOME TO QUOCTHIEN",
          imageUrl: 'assets/images/icon1.png',
          textSize: 24,
          imgWidth: 200,
          imgHeight: 150,
        ),
      ),
    );
  }
}
