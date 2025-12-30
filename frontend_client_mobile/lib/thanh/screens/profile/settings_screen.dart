import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  String _language = 'Vietnamese';
  String _currency = 'VND';

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final screenTheme = base.copyWith(
      textTheme: GoogleFonts.loraTextTheme(base.textTheme),
    );

    return Theme(
      data: screenTheme,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: [
            _SettingsSection(
              title: 'Notifications',
              children: [
                _SwitchSettingTile(
                  title: 'Enable Notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _SwitchSettingTile(
                  title: 'Email Notifications',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _SwitchSettingTile(
                  title: 'Push Notifications',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
              ],
            ),
            _SettingsSection(
              title: 'Preferences',
              children: [
                _ListSettingTile(
                  title: 'Language',
                  value: _language,
                  onTap: () {
                    _showLanguageDialog();
                  },
                ),
                _ListSettingTile(
                  title: 'Currency',
                  value: _currency,
                  onTap: () {
                    _showCurrencyDialog();
                  },
                ),
              ],
            ),
            _SettingsSection(
              title: 'About',
              children: [
                _SimpleSettingTile(
                  title: 'Terms & Conditions',
                  onTap: () {},
                ),
                _SimpleSettingTile(
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _SimpleSettingTile(
                  title: 'App Version',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language', style: GoogleFonts.lora()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Vietnamese', 'English', 'Chinese']
              .map((lang) => RadioListTile<String>(
                    title: Text(lang),
                    value: lang,
                    groupValue: _language,
                    onChanged: (value) {
                      setState(() {
                        _language = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Currency', style: GoogleFonts.lora()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['VND', 'USD', 'EUR']
              .map((curr) => RadioListTile<String>(
                    title: Text(curr),
                    value: curr,
                    groupValue: _currency,
                    onChanged: (value) {
                      setState(() {
                        _currency = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: GoogleFonts.lora(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SwitchSettingTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: GoogleFonts.lora()),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.black,
      ),
    );
  }
}

class _ListSettingTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ListSettingTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: GoogleFonts.lora()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SimpleSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SimpleSettingTile({
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: GoogleFonts.lora()),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

