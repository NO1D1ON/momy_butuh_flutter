import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/controllers/baby_sitter_controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import '../../../utils/theme.dart';

class BabysitterDetailView extends GetView<BabysitterDetailController> {
  const BabysitterDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Babysitter")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        if (controller.babysitter.value == null) {
          return const Center(child: Text("Data tidak ditemukan."));
        }

        final babysitter = controller.babysitter.value!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Header ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            babysitter.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                " 5.0 (20 ulasan)",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Senin - Sabtu, 07:30 - 21:00",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Rp ${babysitter.ratePerHour}/jam",
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // --- Bagian Tombol ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Navigasi ke halaman chat dan kirim data babysitter
                          Get.toNamed(Routes.CHAT, arguments: babysitter);
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text("Chat"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        // UBAH BAGIAN INI
                        onPressed: () {
                          // Arahkan ke halaman booking dan kirim data babysitter
                          Get.toNamed(Routes.BOOKING, arguments: babysitter);
                        },
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: const Text("Booking"),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // --- Bagian Tentang Saya ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tentang Saya",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      babysitter.bio,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
              ),
              // --- Bagian Tab ---
              // (Untuk saat ini kita buat UI-nya, fungsionalitas di bagian selanjutnya)
              const DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppTheme.primaryColor,
                      tabs: [
                        Tab(text: "Ulasan"),
                        Tab(text: "Foto"),
                        Tab(text: "Pengalaman"),
                      ],
                    ),
                    SizedBox(
                      height: 200, // Beri tinggi agar konten tab terlihat
                      child: TabBarView(
                        children: [
                          Center(
                            child: Text("Konten Ulasan akan tampil di sini"),
                          ),
                          Center(
                            child: Text("Konten Foto akan tampil di sini"),
                          ),
                          Center(
                            child: Text(
                              "Konten Pengalaman akan tampil di sini",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
