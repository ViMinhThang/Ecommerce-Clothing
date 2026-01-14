import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/auth/blank_form.dart';
import 'package:frontend_client_mobile/widgets/common/logo_and_text_widget.dart';
import 'package:frontend_client_mobile/widgets/common/mxh_fields_widget.dart';
import 'package:frontend_client_mobile/services/auth_service.dart';

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
  bool _loading = false;

  Future<void> _doLogin() async {
    debugPrint('Login attempt started: ${_username.text.trim()}');
    setState(() => _loading = true);
    try {
      final roles = await _authService.login(
        username: _username.text.trim(),
        password: _password.text,
      );
      debugPrint('Login successful. Roles: $roles');
      if (!mounted) return;

      if (roles.contains('ROLE_ADMIN')) {
        debugPrint('Admin user - navigating to /dashboard');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        debugPrint('Regular user - navigating to /home');
        Navigator.pushReplacementNamed(context, '/home');
      }
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
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
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
                      : const Text('Sign In'),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                "Or sign in with",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              SocialWidget(type: "google", text: "Sign in with Google"),
              const SizedBox(height: 12),
              SocialWidget(type: "facebook", text: "Sign in with Facebook"),
              const SizedBox(height: 12),
              SocialWidget(type: "apple", text: "Sign in with Apple"),

              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlankFormScreen(),
                      ),
                    ),
                    child: const Text(
                      " Sign Up",
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
