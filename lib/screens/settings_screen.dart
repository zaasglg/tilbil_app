import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Настройки',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: "AtypDisplay",
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language section
            _buildSectionHeader('Язык'),
            _buildNavigationItem('Родной язык'),
            
            const SizedBox(height: 20),
            
            // Other settings section
            _buildSectionHeader('Другие'),
            _buildSwitchItem('Темный режим', _isDarkModeEnabled, (value) {
              setState(() {
                _isDarkModeEnabled = value;
              });
            }),
            _buildNavigationItem('Уведомление'),
            _buildNavigationItem('Размер текста'),
            _buildNavigationItem('Звук и громкость'),
            _buildNavigationItem('политика конфиденциальности'),
            _buildNavigationItem('Условия и положения'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 16,
          fontFamily: "AtypDisplay",
        ),
      ),
    );
  }

  Widget _buildNavigationItem(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "AtypDisplay",
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        onTap: () {},
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "AtypDisplay",
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
