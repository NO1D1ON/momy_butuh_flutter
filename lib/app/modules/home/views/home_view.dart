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
                readOnly: true,
                onTap: () => Get.toNamed(Routes.BABYSITTER_SEARCH),
                decoration: InputDecoration(
                  hintText: 'Cari Babysitter...',
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
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.babysitterList.length,
                  itemBuilder: (context, index) {
                    final babysitter = controller.babysitterList[index];
                    return InkWell(
                      onTap: () => Get.toNamed(
                        Routes.BABYSITTER_DETAIL,
                        arguments: babysitter.id,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primaryColor,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            babysitter.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${babysitter.age} Tahun",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text("5.0", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.favorite_border,
                            color: Colors.grey.shade400,
                          ),
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
