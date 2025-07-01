import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/controllers/baby_sitter_controller.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/models/babysitter_availibility_model.dart';
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
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.currentBabysitter == null) {
          return const Center(child: Text("Data babysitter tidak ditemukan."));
        }

        // Definisikan variabel dengan benar dari controller
        final babysitter = controller.currentBabysitter!;
        final availability = controller.currentAvailability;
        final isBookingEnabled = availability != null;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(babysitter, availability),
              const Divider(),
              // Tampilkan info jadwal hanya jika ada
              if (availability != null) ...[
                _buildAvailabilityInfo(availability),
                const Divider(),
              ],
              _buildActionButtons(babysitter, isBookingEnabled),
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

  Widget _buildHeader(
    Babysitter babysitter,
    BabysitterAvailability? availability,
  ) {
    final displayName = controller.displayName;
    final displayPhotoUrl = controller.displayPhotoUrl;
    final displayAge = controller.displayAge;
    final displayRating = controller.displayRating;
    final ratePerHour = availability?.ratePerHour ?? babysitter.ratePerHour;
    final reviewCount = babysitter.reviews.length;
    final address = availability?.locationPreference ?? babysitter.address;

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
                imageUrl: displayPhotoUrl ?? '',
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
                  displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${NumberFormat('#,##0', 'id_ID').format(ratePerHour)}/jam",
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
                      " ${displayRating.toStringAsFixed(1)} ($reviewCount ulasan)",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "$displayAge tahun, dari $address",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityInfo(BabysitterAvailability availability) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Jadwal Tersedia",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.calendar_today,
            "Tanggal",
            _formatDate(availability.availableDate),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.access_time,
            "Waktu",
            "${availability.startTime.substring(0, 5)} - ${availability.endTime.substring(0, 5)}",
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.location_on,
            "Lokasi Preferensi",
            availability.locationPreference,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMMM y', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildActionButtons(Babysitter babysitter, bool isBookingEnabled) {
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
              onPressed: isBookingEnabled
                  ? () {
                      Get.toNamed(
                        Routes.BOOKING,
                        arguments: controller.currentAvailability,
                      );
                    }
                  : null,
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text("Booking"),
              style: ElevatedButton.styleFrom(
                backgroundColor: isBookingEnabled
                    ? AppTheme.primaryColor
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Babysitter babysitter) {
    final bio = babysitter.bio ?? 'Tidak ada informasi bio tersedia.';
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
          Text(bio, style: const TextStyle(color: Colors.black54, height: 1.5)),
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
          Text(
            "Ulasan Pengguna (${reviews.length})",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final userName = review.user?.name;
              final initial = (userName != null && userName.isNotEmpty)
                  ? userName.substring(0, 1).toUpperCase()
                  : 'U';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  title: Text(
                    userName ?? 'User Anonim',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      review.comment,
                      style: const TextStyle(height: 1.3),
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          review.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
