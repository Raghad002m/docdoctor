// lib/main.dart
import 'package:flutter/material.dart';
import 'core/api_config.dart';

// استدعاء الشاشات
import 'Screen/SplashScreen.dart';
import 'Screen/SignInScreen.dart';
import 'Screen/signup.dart';
import 'Screen/onboardScreen.dart';
import 'Screen/HomeScreen.dart';
import 'Screen/DoctorSpeciality.dart';
import 'Screen/RecommendationDoctor.dart';
import 'Screen/NotificationScreen.dart';
import 'Screen/profileScreen.dart';
import 'Screen/MessagesScreen.dart';
import 'Screen/SearchScreen.dart';
import 'Screen/SettingScreen.dart';
import 'Screen/doctorDetailScreen.dart';
import 'Screen/AppointmentScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiConfig.init(); // تهيئة API
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VCare',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // أول شاشة
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/signup': (context) => const signup(),
        '/onboard': (context) => const onboardScreen(),

        '/home': (context) => const HomeScreen(),
        '/DoctorSpeciality': (context) => const Doctorspeciality(),
        '/RecommendationDoctor': (context) => const RecommendationDoctor(),
        '/NotificationScreen': (context) => const NotificationScreen(),
        '/ProfileScreen': (context) => const ProfileScreen(),
        '/MessagesScreen': (context) => const MessagesScreen(),
        '/SearchScreen': (context) => const SearchScreen(),
        '/SettingsScreen': (context) => const SettingsScreen(),
      },

      // ✅ استخدام onGenerateRoute للشاشات اللي إلها باراميتر
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/DoctorDetailScreen':
            final doctorId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => DoctorDetailScreen(doctorId: doctorId),
            );
          case '/AppointmentScreen':
            final doctorId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => AppointmentScreen(doctorId: doctorId),
            );
          default:
            return null;
        }
      },

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
