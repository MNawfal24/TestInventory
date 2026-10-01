import 'package:flutter/material.dart';

import '../../data/mock_data.dart';

class ProfilePage extends StatelessWidget {
  final InventoryStore store;

  const ProfilePage({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          100,
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    child: Icon(
                      Icons.store,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Kopi Senja Cafe',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Cafe & Coffee Shop',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _MenuItem(
              icon: Icons.storefront_outlined,
              title: 'Store Information',
              subtitle: 'Manage your store profile',
              onTap: () {
                _showInfoDialog(
                  context,
                  'Store Information',
                  'Kopi Senja Cafe\nMalang, Indonesia',
                );
              },
            ),

            _MenuItem(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {
                _showInfoDialog(
                  context,
                  'Notifications',
                  'Low stock notifications are enabled.',
                );
              },
            ),

            _MenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Application settings',
              onTap: () {
                _showInfoDialog(
                  context,
                  'Settings',
                  'Settings page will be connected later.',
                );
              },
            ),

            _MenuItem(
              icon: Icons.info_outline,
              title: 'About Myventory',
              subtitle: 'Smart Inventory for UMKM',
              onTap: () {
                _showInfoDialog(
                  context,
                  'About Myventory',
                  'Smart Inventory prototype for UMKM and cafe businesses.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}