import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streaksky/core/theme/app_theme.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).asData?.value;


    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('PROFILE', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.neonAccent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonAccent.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[900],
                      child: const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.neonAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user?.email ?? 'Champion User',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'STREAK LEGEND',
              style: TextStyle(color: AppTheme.neonAccent, letterSpacing: 1.5, fontSize: 12),
            ),
            const SizedBox(height: 40),
            _buildProfileMenuItem(context, Icons.history, 'History', 'View your past streaks'),
            _buildProfileMenuItem(context, Icons.badge_outlined, 'Badges', '12 earned'),
            _buildProfileMenuItem(context, Icons.notifications_outlined, 'Notifications', 'On'),
            _buildProfileMenuItem(context, Icons.security, 'Privacy', 'Manage your data'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.neonAccent),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () {},
      ),
    );
  }
}

