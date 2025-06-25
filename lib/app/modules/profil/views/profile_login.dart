import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/profile_controller.dart';
import '../../../utils/theme.dart';
import '../../../routes/app_pages.dart'; // Tambahkan jika belum ada

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
      // Gunakan Obx untuk membuat UI reaktif terhadap perubahan state
      body: Obx(() {
        // Tampilkan loading indicator jika sedang memuat
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        // Tampilkan pesan jika data gagal dimuat
        if (controller.userProfile.value == null) {
          return const Center(child: Text("Gagal memuat data profil."));
        }

        // Jika data ada, tampilkan
        final user = controller.userProfile.value!;

        return RefreshIndicator(
          onRefresh: () async => controller.fetchProfile(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Bagian Header Profil
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bagian Saldo & Top Up
              Card(
                color: AppTheme.primaryColor.withOpacity(0.1),
                elevation: 0,
                child: ListTile(
                  title: const Text(
                    "Saldo Anda",
                    style: TextStyle(color: Colors.grey),
                  ),
                  subtitle: Text(
                    "Rp ${NumberFormat('#,##0', 'id_ID').format(user.balance)}",
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      var result = await Get.toNamed(Routes.TOPUP);
                      if (result == true) {
                        controller
                            .fetchProfile(); // Refresh data profil jika top up berhasil
                      }
                    },
                    child: const Text("Top Up"),
                  ),
                ),
              ),
              const Divider(height: 40),

              // Menu-menu lain
              _buildProfileMenu(
                icon: Icons.person_outline,
                title: "Edit Profil",
                onTap: () {},
              ),
              _buildProfileMenu(
                icon: Icons.receipt_long_outlined,
                title: "Riwayat Transaksi",
                onTap: () {
                  Get.toNamed(Routes.TRANSACTION_HISTORY);
                },
              ),
              _buildProfileMenu(
                icon: Icons.settings_outlined,
                title: "Pengaturan",
                onTap: () {},
              ),
              _buildProfileMenu(
                icon: Icons.logout,
                title: "Logout",
                onTap: () => controller.logout(),
                textColor: AppTheme.primaryColor,
              ),
            ],
          ),
        );
      }),
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
