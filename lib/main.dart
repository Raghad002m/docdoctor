import 'package:flutter/material.dart';
import 'Screen/ChatScreen.dart';
import 'Screen/DoctorSpeciality.dart';
import 'Screen/HomeScreen.dart';
import 'Screen/MessagesScreen.dart';
import 'Screen/NotificationScreen.dart';
import 'Screen/RecommendationDoctor.dart';
import 'Screen/SearchScreen.dart';
import 'Screen/SettingScreen.dart';
import 'Screen/SignInScreen.dart';
import 'Screen/SplashScreen.dart';
import 'Screen/onboardScreen.dart';
import 'Screen/profileScreen.dart';
import 'Screen/signup.dart';


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
          '/signup': (context) => const signup(),
          '/onboard': (context) => const onboardScreen(),
          '/home': (context) => const HomeScreen(),
          '/DoctorSpeciality': (context) => const Doctorspeciality(),
          '/RecommendationDoctor': (context) => const RecommendationDoctor(),
          '/NotificationScreen': (context) => const NotificationScreen(),
          '/ProfileScreen' : (context) => const ProfileScreen(),
          '/MessagesScreen' : (context) => const MessagesScreen(),
          '/SearchScreen' : (context) => const SearchScreen(),
          '/SettingsScreen' : (context) => const SettingsScreen(),


        });
  }}