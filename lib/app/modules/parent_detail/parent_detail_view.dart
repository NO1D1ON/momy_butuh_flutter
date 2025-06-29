import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/parent_detail/parent_detail_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class ParentDetailView extends GetView<ParentDetailController> {
  const ParentDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pemesan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.parentProfile.value == null) {
          return const Center(child: Text("Gagal memuat data pemesan."));
        }

        final parent = controller.parentProfile.value!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Bagian Header
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    parent.name.substring(0, 1).toUpperCase(),
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
                      parent.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      parent.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 40, thickness: 1),

            // Bagian Detail Kontak
            _buildInfoRow(
              Icons.phone,
              "Nomor Telepon",
              parent.phoneNumber ?? 'Tidak tersedia',
            ),
            _buildInfoRow(
              Icons.location_on,
              "Alamat",
              parent.address ?? 'Tidak tersedia',
            ),
          ],
        );
      }),
    );
  }

  // Widget helper untuk membuat baris info lebih rapi
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
