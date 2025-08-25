import 'package:flutter/material.dart';
import 'package:docdoctor/data/services/api_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;

  void _onLoginPressed() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await ApiService.instance.login(email, password);

      if (res['status'] == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final msg = res['message'] ?? (res['data']?.toString() ?? 'خطأ غير معروف');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network/Server error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF247CFF),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We're excited to have you back, can't wait to see what you've been up to since you last logged in.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (val) {}),
                      const Text("Remember me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFF247CFF)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF247CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _loading ? null : _onLoginPressed,
                  child: _loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 50),
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Or sign in with"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const AssetImage("assets/google.jpg"),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const AssetImage("assets/facebook.jpg"),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const AssetImage("assets/apple.jpg"),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                "By logging, you agree to our Terms & Conditions and Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account yet? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
