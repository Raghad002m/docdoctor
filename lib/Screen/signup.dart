import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class signup extends StatelessWidget {
  const signup({super.key});

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
                "Sign up now and start exploring all that our app has to offer. We're excited to welcome you to our community!",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              TextField(
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

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (code) {},
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

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or sign in with",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage("assets/google.jpg"),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage("assets/facebook.jpg"),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage("assets/apple.jpg"),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text.rich(
                TextSpan(
                  text: "By logging, you agree to our ",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: const TextStyle( color: Colors.blue),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: const TextStyle( color: Colors.blue),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account yet?",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signIn');

                    },
                    child: const Text(
                      "signIn",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String imageUrl) {
    return InkWell(
      onTap: () {},
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[200],
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
