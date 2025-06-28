import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';
import '../controllers/booking_history_controller.dart';

class BookingHistoryView extends GetView<BookingHistoryController> {
  const BookingHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Booking'), centerTitle: true),
      body: Obx(() {
        // Tampilkan loading indicator jika isLoading true
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // Tampilkan pesan jika daftar booking kosong
        if (controller.bookingList.isEmpty) {
          return const Center(
            child: Text("Anda belum memiliki riwayat booking."),
          );
        }

        // Tampilkan daftar booking jika ada data
        return ListView.builder(
          itemCount: controller.bookingList.length,
          itemBuilder: (context, index) {
            // Ambil data booking dari controller
            final booking = controller.bookingList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  "Booking dengan ${booking.babysitterName}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Tanggal: ${booking.bookingDate}\nStatus: ${booking.status}",
                ),
                isThreeLine: true,
                // Tombol aksi berdasarkan status booking
                trailing: _buildTrailingButton(context, booking),
              ),
            );
          },
        );
      }),
    );
  }

  // Widget helper untuk membangun tombol di trailing
  Widget? _buildTrailingButton(BuildContext context, dynamic booking) {
    if (booking.status == 'confirmed') {
      return ElevatedButton(
        onPressed: () => controller.completeBooking(booking.id),
        child: const Text('Selesaikan'),
      );
    } else if (booking.status == 'completed' &&
        booking.review == null /* Tambah kondisi cek ulasan */ ) {
      return ElevatedButton(
        onPressed: () {
          // Panggil dialog untuk memberi ulasan
          _showReviewDialog(context, booking.id);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        child: const Text('Beri Ulasan'),
      );
    } else if (booking.status == 'completed' && booking.review != null) {
      return const Chip(
        label: Text("Reviewed", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 8),
      );
    }
    // Jika status lainnya, tidak ada tombol
    return null;
  }

  // Dialog untuk memberi ulasan. Tetap di View karena ini adalah komponen UI.
  void _showReviewDialog(BuildContext context, int bookingId) {
    final rating = 0.0.obs;
    final commentController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Beri Ulasan Anda'),
        content: SingleChildScrollView(
          // Agar tidak overflow saat keyboard muncul
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rating Bar
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) {
                  rating.value = value;
                },
              ),
              const SizedBox(height: 16),
              // Text Field untuk Komentar
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
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (rating.value > 0) {
                Get.back(); // Tutup dialog
                // Panggil metode postReview di controller
                controller.postReview(
                  bookingId,
                  rating.value.toInt(),
                  commentController.text,
                );
              } else {
                Get.snackbar(
                  "Error",
                  "Rating tidak boleh kosong.",
                  snackPosition: SnackPosition.TOP,
                );
              }
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }
}
