import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class onboardScreen extends StatefulWidget {
  const onboardScreen({super.key});

  @override
  State<onboardScreen> createState() => _onboardScreenState();
}

class _onboardScreenState extends State<onboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height:30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/logo.png",height: 30,),
                      SizedBox(width: 10,),
                      const Text (
                        "Docdoc",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ).createShader(bounds),
                      blendMode: BlendMode.dstOut,
                      child: Image.asset(
                        'assets/Doctor.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const Text(
                    "Best Doctor Appointment App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF247CFF),

                    ),
                  ),
                  const SizedBox(height: 10,),


                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Manage and schedule all of your medical appointments easily with Dodoc to get a new experience.'
                      ,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14,
                          color:Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),


                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signIn');


                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF247CFF),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Get Started", style: TextStyle(color: Colors.white),),
                      ),),
                  ),
                ],
              )),
        ));
  }
}