import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/auth/blank_form.dart';
import 'package:frontend_client_mobile/widgets/app_bar_widget.dart';
import 'package:frontend_client_mobile/widgets/logo_and_text_widget.dart';
import 'package:frontend_client_mobile/widgets/mxh_fields_widget.dart';

void main() {
  runApp(MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "", icons: null),

      body: Container(
        decoration: BoxDecoration(color: Colors.white),

        child: Column(
          children: [
            SizedBox(height: 5),
            LogoTextWidget(
              text: "WELCOME TO QUOCTHIEN",
              imageUrl: 'assets/images/icon1.png',
              textSize: 16,
              imgHeight: 100,
              imgWidth: 150,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),

            SocialWidget(
              icondata: Icons.g_mobiledata_outlined,
              text: "Đăng nhập Bằng Google",
              textColor: Colors.black,
              color: Colors.white,
            ),
            SizedBox(height: 15),
            SocialWidget(
              icondata: Icons.facebook_outlined,
              text: "Đăng nhập Bằng Facebook",
              textColor: Colors.white,
              color: Colors.blue,
            ),
            SizedBox(height: 15),
            SocialWidget(
              icondata: Icons.apple_outlined,
              text: "Đăng nhập Bằng Apple",
              textColor: Colors.white,
              color: Colors.black,
            ),
            SizedBox(height: 25),

            Text(
              "_____________or____________",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 15),
            SocialWidget(
              icondata: null,
              text: "Đăng nhập bằng password",
              textColor: Colors.white,
              color: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlankFormScreen()),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chưa có tài khoản?",
                  style: TextStyle(color: Colors.black),
                ),
                InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlankFormScreen(),
                      ),
                    ),
                  },

                  child: Text(
                    " Đăng ký",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
