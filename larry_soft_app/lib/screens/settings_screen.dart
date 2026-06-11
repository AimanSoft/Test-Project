import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Account Info',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(provider.currentUser?.username ?? 'Guest'),
                  subtitle: Text(provider.currentUser?.email ?? 'No email provided'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'App Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable or disable dark theme'),
                secondary: const Icon(Icons.brightness_4),
                value: provider.isDarkMode,
                onChanged: (value) => provider.toggleTheme(),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: const Text('English'),
                onTap: () {
                  // Implement language change
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {},
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  provider.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
