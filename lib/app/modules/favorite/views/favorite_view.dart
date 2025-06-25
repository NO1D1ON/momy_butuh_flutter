import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import '../controllers/favorite_controller.dart';
import '../../../utils/theme.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Babysitter Favorit'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Tampilkan loading indicator jika sedang memuat
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        // Tampilkan pesan jika daftar kosong
        if (controller.favoriteList.isEmpty) {
          return const Center(
            child: Text(
              'Anda belum memiliki babysitter favorit.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        // Tampilkan daftar jika ada data
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.favoriteList.length,
          itemBuilder: (context, index) {
            final babysitter = controller.favoriteList[index];
            // Kita gunakan ListTile yang simpel untuk halaman favorit
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  babysitter.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(babysitter.address),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
                onTap: () {
                  Get.toNamed(
                    Routes.BABYSITTER_DETAIL,
                    arguments: babysitter.id,
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
