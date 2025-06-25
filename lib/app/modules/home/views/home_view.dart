import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../utils/theme.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Beri warna latar yang lembut
      // Gunakan Floating Action Button untuk "Buat Penawaran"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.CREATE_JOB_OFFER),
        label: const Text("Buat Penawaran"),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.fetchBabysitters(),
          color: AppTheme.primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- WIDGET BAGIAN ATAS ---
              Obx(
                () => Text(
                  "Halo, ${controller.parentName.value}!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                "Temukan pengasuh terbaik untuk buah hati Anda.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // --- WIDGET PENCARIAN ---
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari berdasarkan nama...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- JUDUL DAFTAR ---
              const Text(
                "Rekomendasi Babysitter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // --- DAFTAR BABYSITTER DINAMIS ---
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }
                if (controller.babysitterList.isEmpty) {
                  return const Center(
                    child: Text("Belum ada babysitter yang tersedia."),
                  );
                }
                // Gunakan GridView untuk tampilan 2 kolom yang modern
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.babysitterList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kartu per baris
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8, // Atur rasio kartu
                  ),
                  itemBuilder: (context, index) {
                    final babysitter = controller.babysitterList[index];
                    // Widget kartu kustom untuk setiap babysitter
                    return InkWell(
                      onTap: () => Get.toNamed(
                        Routes.BABYSITTER_DETAIL,
                        arguments: babysitter.id,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: Center(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppTheme.primaryColor,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      babysitter.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${babysitter.age} Tahun",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            Text(
                                              " 5.0",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Obx(() {
                                          // Cek apakah ID babysitter ada di dalam list favorit
                                          final isFavorite = controller
                                              .favoriteIds
                                              .contains(babysitter.id);
                                          return IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? AppTheme.primaryColor
                                                  : Colors.grey.shade400,
                                              size: 22,
                                            ),
                                            // Panggil fungsi toggle dari controller saat ditekan
                                            onPressed: () => controller
                                                .toggleFavorite(babysitter.id),
                                          );
                                        }),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
