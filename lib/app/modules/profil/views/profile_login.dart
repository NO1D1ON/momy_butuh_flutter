import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../utils/theme.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bagian Header Profil
          const Row(
            children: [
              CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama Pengguna",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "email@pengguna.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 40),

          // Menu-menu
          _buildProfileMenu(
            icon: Icons.person_outline,
            title: "Edit Profil",
            onTap: () {},
          ),
          _buildProfileMenu(
            icon: Icons.receipt_long_outlined,
            title: "Riwayat Transaksi",
            onTap: () {},
          ),
          _buildProfileMenu(
            icon: Icons.settings_outlined,
            title: "Pengaturan",
            onTap: () {},
          ),
          _buildProfileMenu(
            icon: Icons.logout,
            title: "Logout",
            onTap: () => controller.logout(), // Panggil fungsi logout
            textColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[700]),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
