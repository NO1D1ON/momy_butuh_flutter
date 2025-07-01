import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';
import '../controllers/booking_history_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookingHistoryView extends GetView<BookingHistoryController> {
  const BookingHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking Saya'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchBookingHistory(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        bool allEmpty =
            controller.pendingBookings.isEmpty &&
            controller.ongoingBookings.isEmpty &&
            controller.completedBookings.isEmpty;

        if (allEmpty) {
          return const Center(
            child: Text("Anda belum memiliki riwayat booking."),
          );
        }

        // Menggunakan ListView untuk menampilkan beberapa seksi data.
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildBookingSection(
              title: "Menunggu Persetujuan",
              bookings: controller.pendingBookings,
              icon: Icons.hourglass_top_rounded,
              color: Colors.amber.shade700,
            ),
            _buildBookingSection(
              title: "Sedang Berjalan",
              bookings: controller.ongoingBookings,
              icon: Icons.directions_run_rounded,
              color: Colors.blue.shade700,
              isOngoing: true,
            ),
            _buildBookingSection(
              title: "Riwayat Selesai",
              bookings: controller.completedBookings,
              icon: Icons.check_circle_rounded,
              color: Colors.green.shade700,
              isCompleted: true,
            ),
          ],
        );
      }),
    );
  }

  /// Helper widget untuk membuat setiap seksi booking (Menunggu, Berjalan, Selesai).
  Widget _buildBookingSection({
    required String title,
    required List<Booking> bookings,
    required IconData icon,
    required Color color,
    bool isOngoing = false,
    bool isCompleted = false,
  }) {
    if (bookings.isEmpty) {
      return const SizedBox.shrink(); // Tidak menampilkan seksi jika datanya kosong.
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        // Membuat daftar Card untuk setiap booking di dalam seksi ini.
        ...bookings.map((booking) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              title: Text(
                "Booking dengan ${booking.babysitterName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Tanggal: ${DateFormat('d MMM y, HH:mm', 'id_ID').format(booking.jobDate)}\nStatus: ${booking.status.replaceAll('_', ' ').capitalizeFirst}",
              ),
              isThreeLine: true,
              // Menentukan tombol aksi berdasarkan jenis seksi.
              trailing: isOngoing
                  ? _buildActionButton(booking)
                  : (isCompleted ? _buildReviewButton(booking) : null),
            ),
          );
        }).toList(),
      ],
    );
  }

  /// Helper untuk membangun tombol aksi pada booking yang sedang berjalan.
  Widget? _buildActionButton(Booking booking) {
    if (booking.status == 'confirmed' ||
        booking.status == 'babysitter_confirmed') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: () => controller.confirmAsParent(booking.id),
        child: const Text('Selesaikan', style: TextStyle(fontSize: 12)),
      );
    }
    if (booking.status == 'parent_confirmed') {
      return const Chip(
        label: Text('Menunggu Babysitter'),
        backgroundColor: Colors.orangeAccent,
      );
    }
    return null; // Tidak ada aksi untuk status lain.
  }

  /// Helper untuk membangun tombol ulasan pada booking yang sudah selesai.
  Widget? _buildReviewButton(Booking booking) {
    // Tombol hanya relevan untuk booking yang statusnya 'completed'.
    if (booking.status != 'completed') return null;

    // Jika sudah ada ulasan, tampilkan tombol untuk melihat/mengubah.
    if (booking.hasReview) {
      return TextButton(
        onPressed: () => _showReviewDialog(Get.context!, booking),
        child: const Text(
          'Lihat Ulasan',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    } else {
      // Jika belum ada ulasan, tampilkan tombol untuk memberi ulasan.
      return OutlinedButton(
        onPressed: () => _showReviewDialog(Get.context!, booking),
        child: const Text('Beri Ulasan', style: TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.primaryColor),
          foregroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }

  /// Menampilkan dialog untuk memberi atau melihat/mengubah ulasan.
  void _showReviewDialog(BuildContext context, Booking booking) {
    // Isi form dengan data yang sudah ada jika booking.review tidak null.
    final rating = (booking.review?.rating ?? 0.0).obs;
    final commentController = TextEditingController(
      text: booking.review?.comment ?? '',
    );

    Get.dialog(
      AlertDialog(
        title: Text(booking.hasReview ? 'Ulasan Anda' : 'Beri Ulasan Anda'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: rating.value,
                minRating: 1,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) => rating.value = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Komentar Anda (Opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Tutup")),
          ElevatedButton(
            onPressed: () {
              if (rating.value > 0) {
                Get.back();
                controller.postReview(
                  booking.id,
                  rating.value.toInt(),
                  commentController.text,
                );
              } else {
                Get.snackbar(
                  "Rating Wajib",
                  "Mohon berikan minimal 1 bintang.",
                );
              }
            },
            child: Text(booking.hasReview ? "Simpan Perubahan" : "Kirim"),
          ),
        ],
      ),
    );
  }
}
