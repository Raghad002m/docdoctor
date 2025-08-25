// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../models/user_model.dart';
import 'SettingScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.instance.getProfile();
      if (res['status'] == true && res['data'] != null) {
        setState(() => _user =
            UserModel.fromJson(Map<String, dynamic>.from(res['data'])));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res['message'] ?? 'Failed to load profile')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _logout() async {
    await ApiService.instance.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    if (_user == null) {
      return const Scaffold(
          body: Center(child: Text('No user data found')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with Avatar and user info
          Container(
            width: double.infinity,
            color: Colors.blue,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/avatar.png"),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.edit,
                          size: 20, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _user!.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  _user!.email,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _profileButton("My Appointment"),
                    _profileButton("Medical records"),
                  ],
                ),
                const SizedBox(height: 20),

                _profileItem(
                    Icons.person, Colors.blue, "Personal Information"),
                const SizedBox(height: 15),
                _profileItem(Icons.science, Colors.green,
                    "My Test & Diagnostic"),
                const SizedBox(height: 15),
                _profileItem(Icons.payment, Colors.red, "Payment"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileButton(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _profileItem(IconData icon, Color color, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
