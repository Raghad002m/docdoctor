import 'package:docdoctor/screen/auth_screens/signin%20screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../Home/homeScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final api = ApiService();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String phoneFullNumber = "";
  bool loading = false;
  String error = "";

  Future<void> doRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      error = "";
    });

    try {
      // أولاً نسجل المستخدم
      await api.register(
        name: _nameController.text,
        email: _emailController.text,
        phone: phoneFullNumber,
        gender: _genderController.text, // يرسل "0" أو "1"
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      // بعد التسجيل نحضر بيانات المستخدم من البروفايل
      final newUser = await api.getProfile();

      // حفظ بيانات المستخدم محلياً
      if (api.token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", api.token!);
        await prefs.setString("user_name", newUser.name);
        await prefs.setString("user_email", newUser.email);
        await prefs.setString("user_phone", newUser.phone);
        await prefs.setString("user_gender", newUser.gender);
        if (newUser.avatar != null) {
          await prefs.setString("user_avatar", newUser.avatar!);
        }
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF247CFF),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign up now and start exploring all that our app has to offer. We're excited to welcome you to our community!",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? "Enter your email" : null,
                ),
                const SizedBox(height: 16),

                // Gender Dropdown (يرسل "0" أو "1")
                DropdownButtonFormField<String>(
                  value: _genderController.text.isEmpty ? null : _genderController.text,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: const [
                    DropdownMenuItem(value: "0", child: Text("Male")),
                    DropdownMenuItem(value: "1", child: Text("Female")),
                  ],
                  onChanged: (val) {
                    _genderController.text = val ?? "";
                  },
                  validator: (v) => (v == null || v.isEmpty) ? "Select your gender" : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                  validator: (v) => v!.length < 6 ? "At least 6 chars" : null,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                  validator: (v) => v != _passwordController.text ? "Passwords do not match" : null,
                ),
                const SizedBox(height: 16),

                // Phone with country picker
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Your number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  initialCountryCode: 'US',
                  onChanged: (phone) {
                    phoneFullNumber = phone.completeNumber;
                  },
                  validator: (v) =>
                  v == null || v.number.isEmpty ? "Enter your phone" : null,
                ),
                const SizedBox(height: 24),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF247CFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: loading ? null : doRegister,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Create Account", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),

                const Center(
                  child: Text("— Or sign in with —", style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 16),

                // Social icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon("assets/google.jpg"),
                    const SizedBox(width: 24),
                    _socialIcon("assets/facebook.jpg"),
                    const SizedBox(width: 24),
                    _socialIcon("assets/apple.jpg"),
                  ],
                ),

                const SizedBox(height: 24),
                const Text(
                  "By signing up, you agree to our Terms & Conditions and Privacy Policy.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFF247CFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                if (error.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(error, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String path) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        shape: BoxShape.circle,
      ),
      child: Center(child: Image.asset(path, width: 24, height: 24)),
    );
  }
}
