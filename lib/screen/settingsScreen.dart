import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_SettingItem>[
      _SettingItem(
        icon: Icons.notifications_none,
        title: 'Notification',
        color: Colors.black87,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
          );
        },
      ),

      _SettingItem(
        icon: Icons.help_outline,
        title: 'FAQ',
        color: Colors.black87,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FAQScreen()),
        ),
      ),
      _SettingItem(
        icon: Icons.lock_outline,
        title: 'Security',
        color: Colors.black87,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SecurityScreen()),
        ),
      ),
      _SettingItem(
        icon: Icons.language_outlined,
        title: 'Language',
        color: Colors.black87,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LanguageScreen()),
        ),
      ),
      _SettingItem(
        icon: Icons.logout,
        title: 'Logout',
        color: Colors.red,
        onTap: () => _confirmLogout(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Setting', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final it = items[i];
          return ListTile(
            leading: Icon(it.icon, color: it.title == 'Logout' ? Colors.red : Colors.black87),
            title: Text(
              it.title,
              style: TextStyle(
                color: it.color,
                fontWeight: it.title == 'Logout' ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: it.onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          );
        },
      ),
    );
  }

  static Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );
    if (ok == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoggedOutPlaceholder()),
            (route) => false,
      );
    }
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  _SettingItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}




class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool notificationFromDocNow = true;
  bool sound = true;
  bool vibrate = true;
  bool appUpdates = false;
  bool specialOffers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSwitchTile("Notification from DocNow", notificationFromDocNow, (value) {
            setState(() {
              notificationFromDocNow = value;
            });
          }),
          _buildSwitchTile("Sound", sound, (value) {
            setState(() {
              sound = value;
            });
          }),
          _buildSwitchTile("Vibrate", vibrate, (value) {
            setState(() {
              vibrate = value;
            });
          }),
          _buildSwitchTile("App Updates", appUpdates, (value) {
            setState(() {
              appUpdates = value;
            });
          }),
          _buildSwitchTile("Special Offers", specialOffers, (value) {
            setState(() {
              specialOffers = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      value: value,
      activeColor: Colors.blue,
      onChanged: onChanged,
    );
  }
}


class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        "question": "What should I expect during a doctor's appointment?",
        "answer":
        "During a doctor’s appointment, you can expect to discuss your medical history, current symptoms or concerns, and any medications or treatments you are taking. The doctor may also perform a physical exam and may order additional tests or procedures if necessary."
      },
      {
        "question": "What should I bring to my doctor's appointment?",
        "answer":
        "Bring your ID, insurance card, list of medications, and any relevant medical documents."
      },
      {
        "question": "What if I need to cancel or reschedule my appointment?",
        "answer":
        "Contact the clinic as soon as possible to cancel or reschedule your appointment."
      },
      {
        "question": "How do I make an appointment with a doctor?",
        "answer":
        "You can make an appointment by calling the clinic or booking through the app/website."
      },
      {
        "question": "How early should I arrive for my doctor's appointment?",
        "answer":
        "It’s recommended to arrive 10-15 minutes early to complete any necessary paperwork."
      },
      {
        "question": "How long will my doctor's appointment take?",
        "answer":
        "Appointments usually take between 15 to 30 minutes, depending on the reason for the visit."
      },
      {
        "question": "How much will my doctor's appointment cost?",
        "answer":
        "The cost varies depending on your insurance coverage and the type of consultation."
      },
      {
        "question": "What should I look for in a good doctor?",
        "answer":
        "Look for a doctor who listens carefully, communicates clearly, and shows compassion."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "FAQ",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              faqs[index]["question"]!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            children: [
              Text(
                faqs[index]["answer"]!,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, height: 1.4),
              ),
            ],
          );
        },
      ),
    );
  }
}


class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool rememberPassword = true;
  bool faceId = false;
  bool pin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Security",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            value: rememberPassword,
            onChanged: (val) {
              setState(() => rememberPassword = val);
            },
            title: const Text("Remember password"),
            activeColor: Colors.blue,
          ),
          SwitchListTile(
            value: faceId,
            onChanged: (val) {
              setState(() => faceId = val);
            },
            title: const Text("Face ID"),
            activeColor: Colors.blue,
          ),
          SwitchListTile(
            value: pin,
            onChanged: (val) {
              setState(() => pin = val);
            },
            title: const Text("PIN"),
            activeColor: Colors.blue,
          ),
          ListTile(
            title: const Text("Google Authenticator"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GoogleAuthenticatorScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class GoogleAuthenticatorScreen extends StatelessWidget {
  const GoogleAuthenticatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Authenticator"),
      ),
      body: const Center(
        child: Text("Google Authenticator settings here"),
      ),
    );
  }
}



class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _lang = 'English';

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Language',
      child: Column(
        children: [
          RadioListTile<String>(
            value: 'English',
            groupValue: _lang,
            title: const Text('English'),
            onChanged: (v) => setState(() => _lang = v!),
          ),
          RadioListTile<String>(
            value: 'العربية',
            groupValue: _lang,
            title: const Text('العربية'),
            onChanged: (v) => setState(() => _lang = v!),
          ),
        ],
      ),
    );
  }
}


class LoggedOutPlaceholder extends StatelessWidget {
  const LoggedOutPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/signIn');
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
class _SubScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _SubScaffold({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [child],
      ),
    );
  }
}