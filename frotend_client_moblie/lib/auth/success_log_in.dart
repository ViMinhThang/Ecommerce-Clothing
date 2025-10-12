import 'package:flutter/material.dart';
import 'package:frotend_client_moblie/widgets/app_bar_widget.dart';
import 'package:frotend_client_moblie/widgets/logo_and_text_widget.dart';
import 'package:frotend_client_moblie/widgets/mxh_fields_widget.dart';

void main() {
  runApp(MaterialApp(home: SuccessScreen()));
}

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
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
              text: "Đăng nhập thành Công!",
              imageUrl: 'assets/images/success.png',
              textSize: 24,
              imgHeight: 200,
              imgWidth: 250,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              "bạn đã đăng ký thành công, chúc mua hàng vui vẻ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.1),

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
                  "Tiếp tục mua hàng",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
