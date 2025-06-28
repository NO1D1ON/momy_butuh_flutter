// File: lib/app/modules/babysitter_home/babysitter_home_view.dart

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
        // RefreshIndicator untuk fitur pull-to-refresh
        child: RefreshIndicator(
          onRefresh: () async => controller.fetchData(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Widget
                      _buildHeader(),
                      const SizedBox(height: 24),
                      const Text(
                        "Penawaran Terbuka",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              // Daftar penawaran dinamis
              _buildJobOfferList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                // Bagian ini sudah benar, akan menampilkan nama secara dinamis
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
          const Icon(Icons.waving_hand, size: 75, color: AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildJobOfferList() {
    return Obx(() {
      if (controller.isLoading.value && controller.jobOfferList.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.jobOfferList.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Text("Belum ada penawaran pekerjaan saat ini.")),
        );
      }
      // Gunakan SliverList untuk performa yang lebih baik di dalam CustomScrollView
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final offer = controller.jobOfferList[index];
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
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    offer.parentName.isNotEmpty
                        ? offer.parentName.substring(0, 1)
                        : 'P',
                    style: const TextStyle(color: AppTheme.primaryColor),
                  ),
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
                  Get.toNamed(Routes.JOB_OFFER_DETAIL, arguments: offer.id);
                },
              ),
            );
          }, childCount: controller.jobOfferList.length),
        ),
      );
    });
  }
}
