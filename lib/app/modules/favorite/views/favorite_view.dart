import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/favorite/controllers/favorite_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- PERBAIKAN DI SINI ---
        // Menambahkan tombol kembali secara eksplisit
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Get.back(), // Fungsi untuk kembali ke halaman sebelumnya
        ),

        // --- BATAS PERBAIKAN ---
        title: const Text(
          'Babysitter Favorit',
          style: TextStyle(
            color: Colors.white,
          ), // Tambahkan warna teks agar kontras
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true, // Agar judul berada di tengah
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        if (controller.favoriteList.isEmpty) {
          return const Center(
            child: Text('Anda belum memiliki babysitter favorit.'),
          );
        }
        return ListView.builder(
          itemCount: controller.favoriteList.length,
          itemBuilder: (context, index) {
            final babysitter = controller.favoriteList[index];
            return ListTile(
              leading: CircleAvatar(
                // Tambahkan logika untuk menampilkan gambar jika ada
                backgroundImage: babysitter.photoUrl != null
                    ? NetworkImage(babysitter.photoUrl!)
                    : null,
                child: babysitter.photoUrl == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(babysitter.name),
              subtitle: Text(babysitter.address ?? 'Lokasi tidak diketahui'),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
                tooltip: 'Hapus dari favorit',
                onPressed: () => controller.removeFromFavorites(babysitter.id),
              ),
              onTap: () => Get.toNamed(
                Routes.BABYSITTER_DETAIL,
                arguments: babysitter.id,
              ),
            );
          },
        );
      }),
    );
  }
}
