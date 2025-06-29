import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/controllers/baby_sitter_controller.dart';
import 'package:momy_butuh_flutter/app/modules/chat/views/chat_view.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/models/review_babysitter_model.dart';
import '../../../utils/theme.dart';
import '../../../routes/app_pages.dart';

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
        if (controller.errorMessage.isNotEmpty &&
            controller.babysitter.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Gagal memuat data.\n${controller.errorMessage.value}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        if (controller.babysitter.value == null) {
          return const Center(child: Text("Data babysitter tidak ditemukan."));
        }
        final babysitter = controller.babysitter.value!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(babysitter),
              const Divider(),
              _buildActionButtons(babysitter),
              const Divider(),
              _buildAboutSection(babysitter),
              const Divider(height: 32),
              _buildReviewsSection(babysitter.reviews),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(Babysitter babysitter) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: babysitter.photoUrl ?? '',
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                placeholder: (context, url) =>
                    const Icon(Icons.person, size: 40, color: Colors.grey),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
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
                Text(
                  "Rp ${babysitter.ratePerHour}/jam",
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      " ${babysitter.rating.toStringAsFixed(1)} (${babysitter.reviews.length} ulasan)",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${babysitter.age} tahun, dari ${babysitter.address}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Babysitter babysitter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Get.toNamed(Routes.CHAT, arguments: babysitter);
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("Chat"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () =>
                  Get.toNamed(Routes.BOOKING, arguments: babysitter),
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text("Booking"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Babysitter babysitter) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tentang Saya",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            babysitter.bio,
            style: const TextStyle(color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(List<Review> reviews) {
    if (reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(child: Text("Belum ada ulasan.")),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ulasan Pengguna",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              // --- PERBAIKAN NULL SAFETY DI SINI ---
              final userName = review.user?.name;
              final initial = (userName != null && userName.isNotEmpty)
                  ? userName.substring(0, 1).toUpperCase()
                  : 'U'; // 'U' untuk User
              // --- BATAS PERBAIKAN ---

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(initial)),
                title: Text(review.user?.name ?? 'User Anonim'),
                subtitle: Text(review.comment ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(review.rating?.toStringAsFixed(1) ?? '0'),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
