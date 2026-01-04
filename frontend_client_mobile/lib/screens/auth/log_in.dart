import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/auth/blank_form.dart';
import 'package:frontend_client_mobile/widgets/common/logo_and_text_widget.dart';
import 'package:frontend_client_mobile/widgets/common/mxh_fields_widget.dart';
import 'package:frontend_client_mobile/services/auth_service.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthService _authService = AuthService();
  final TokenStorage _tokenStorage = TokenStorage();
  bool _loading = false;

  Future<void> _doLogin() async {
    debugPrint('Login attempt started: ${_username.text.trim()}');
    setState(() => _loading = true);
    try {
      await _authService.login(
        username: _username.text.trim(),
        password: _password.text,
      );
      debugPrint('Login service call successful');
      if (!mounted) return;
      debugPrint('Navigating to /home');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('Login error: $e');
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
      debugPrint('Login attempt finished');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              LogoTextWidget(
                text: "WELCOME TO QUOCTHIEN",
                imageUrl: 'assets/images/icon1.png',
                textSize: 16,
                imgHeight: 100,
                imgWidth: 150,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),

              TextField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Trial Credentials:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Username: '),
                        SelectableText(
                          'sys.admin',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Password: '),
                        SelectableText(
                          '123456',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _doLogin,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Đăng nhập'),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                "Hoặc đăng nhập bằng",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              SocialWidget(
                icondata: Icons.g_mobiledata_outlined,
                text: "Đăng nhập Bằng Google",
                textColor: Colors.black,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              SocialWidget(
                icondata: Icons.facebook_outlined,
                text: "Đăng nhập Bằng Facebook",
                textColor: Colors.white,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              SocialWidget(
                icondata: Icons.apple_outlined,
                text: "Đăng nhập Bằng Apple",
                textColor: Colors.white,
                color: Colors.black,
              ),

              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chưa có tài khoản?"),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlankFormScreen(),
                      ),
                    ),
                    child: const Text(
                      " Đăng ký",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
