import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/auth/log_in.dart';
import 'package:frontend_client_mobile/widgets/app_bar_widget.dart';
import 'package:frontend_client_mobile/widgets/logo_and_text_widget.dart';
import 'package:frontend_client_mobile/widgets/social_rounded.dart';

void main() {
  runApp(MaterialApp(home: BlankFormScreen()));
}

class BlankFormScreen extends StatefulWidget {
  const BlankFormScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BlanhFormScreenState();
}

class _BlanhFormScreenState extends State<BlankFormScreen> {
  bool obscureText = true;
  bool isChecked = false;
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

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Nhập email của bạn",
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                  fillColor: Colors.black,

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ), // viền khi focus
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',

                  hintText: 'Nhập mật khẩu',
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.83,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isChecked,
                    checkColor: Colors.white,
                    focusColor: Colors.black,
                    activeColor: Colors.black,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue!;
                      });
                    },
                  ),
                  Text('Remember me'),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  "Đăng ký",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "---------Hay tiếp tục với---------",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SocialRoundedWidget(icondata: Icons.g_mobiledata_outlined),
                  SocialRoundedWidget(icondata: Icons.facebook_outlined),
                  SocialRoundedWidget(icondata: Icons.apple_outlined),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Đã có tài khoản ?",
                  style: TextStyle(color: Colors.black),
                ),
                InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                  },
                  child: Text(
                    " Đăng nhập",
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
