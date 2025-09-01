import 'package:docdoctor/screen/Home/AllSpecialitiesscreen.dart';
import 'package:docdoctor/screen/Home/homeScreen.dart';
import 'package:docdoctor/screen/Home/notificationScreen.dart';
import 'package:docdoctor/screen/Home/recommendedDoctorScreen.dart';
import 'package:docdoctor/screen/appointmentScreen.dart';
import 'package:docdoctor/screen/auth_screens/forgetpassword.dart';
import 'package:docdoctor/screen/auth_screens/profilescreen.dart';
import 'package:docdoctor/screen/auth_screens/signin%20screen.dart';
import 'package:docdoctor/screen/auth_screens/signup%20screen.dart';
import 'package:docdoctor/screen/chatScreen.dart';
import 'package:docdoctor/screen/onboard%20screen.dart';
import 'package:docdoctor/screen/searchScreen.dart';
import 'package:flutter/material.dart';

import 'models/appointment_model.dart';
import 'screen/spalash screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/Register': (context) => const RegisterScreen(),
        '/onboard': (context) => const onboardScreen(),
        '/forget': (context) => const forgetPassword(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/allspecialities': (context) => Allspecialitiesscreen(),
        '/recommendedDoctor': (context) => const RecommendedDoctorScreen(),
        '/appointments': (context) => const AppointmentsScreen(appointments: [],),
        '/notifi': (context) => NotificationPage(),
        '/booking': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return BookingFlow(
            doctorId: args['doctorId'],
            doctorName: args['doctorName'],
          );
        },

        '/chat': (context) => ChatScreen(
          doctorName: "Test Doctor",
          doctorImage: "assets/images/doc.png",
        ),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}