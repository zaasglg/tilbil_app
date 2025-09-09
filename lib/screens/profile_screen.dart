import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'Қолданушы';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('username');
      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          _username = savedUsername;
        });
      }
    } catch (e) {
      print('Error loading username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF333333),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Пайдаланушы профилі',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 40),
            _buildMenuItems(),
            const Spacer(),
            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Simple avatar
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFE8E8E8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 40,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),
        // User name with edit button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        Builder(
          builder: (context) => _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Баптаулар',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          icon: Icons.emoji_events_outlined,
          title: 'Жетістіктер',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (context) => _buildMenuItem(
            icon: Icons.edit_outlined,
            title: 'Профильді өзгерту',
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const ProfileEditScreen(),
              //   ),
              // );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF666666),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFFBBBBBB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          // TODO: Implement logout functionality
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Аккаунттан шығу',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE53E3E),
          ),
        ),
      ),
    );
  }
}
