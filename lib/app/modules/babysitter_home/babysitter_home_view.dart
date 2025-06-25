import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_home/babysitter_home_controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class BabysitterHomeView extends GetView<BabysitterHomeController> {
  const BabysitterHomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async =>
              controller.fetchData(), // Tambahkan fitur pull-to-refresh
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Widget bagian atas seperti sebelumnya
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              "Halo, ${controller.babysitterName.value}!",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Ada penawaran pekerjaan baru untukmu. Ayo lihat!",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    // Anda bisa mengganti ini dengan gambar aset Anda
                    const Icon(
                      Icons.waving_hand,
                      size: 75,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Penawaran Terbuka",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Daftar penawaran dinamis
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.jobOfferList.isEmpty) {
                  return const Center(
                    child: Text("Belum ada penawaran pekerjaan saat ini."),
                  );
                }
                // Gunakan Column dan map untuk membuat daftar Card
                return Column(
                  children: controller.jobOfferList.map((offer) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          child: Text(offer.parentName.substring(0, 1)),
                        ),
                        title: Text(
                          offer.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "Keluarga ${offer.parentName} - ${offer.locationAddress}",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          // Navigasi ke detail penawaran dengan ID
                          Get.toNamed(
                            Routes.JOB_OFFER_DETAIL,
                            arguments: offer.id,
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
