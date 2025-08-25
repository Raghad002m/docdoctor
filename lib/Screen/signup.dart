import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _SignupState();
}

class _SignupState extends State<signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String countryCode = '+44'; // كود افتراضي

  final Dio dio = Dio();

  Future<void> createAccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();

    if (email.isEmpty || password.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final response = await dio.post(
        'https://example.com/api/register', // استبدل بالرابط الصحيح
        data: {
          "email": email,
          "password": password,
          "phone": "$countryCode$phone"
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // نجح التسجيل
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unauthorized. Check your credentials.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign up now and start exploring all that our app has to offer.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 15),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 15),

              // Phone
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (code) {
                        setState(() {
                          countryCode = code.dialCode ?? '+44';
                        });
                      },
                      initialSelection: 'GB',
                      favorite: const ['+44', 'GB'],
                      showFlag: true,
                      flagWidth: 24,
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "Your number",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Button
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
                  onPressed: createAccount,
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
