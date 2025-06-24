import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../controllers/booking_history_controller.dart';

class BookingHistoryView extends GetView<BookingHistoryController> {
  const BookingHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Booking')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.bookingList.length,
          itemBuilder: (context, index) {
            final booking = controller.bookingList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  "Booking dengan ${booking.babysitterName}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Tanggal: ${booking.bookingDate}\nStatus: ${booking.status}",
                ),
                isThreeLine: true,
                // Tampilkan tombol 'Beri Ulasan' jika booking sudah 'completed'
                trailing: booking.status == 'completed'
                    ? ElevatedButton(
                        onPressed: () => _showReviewDialog(context, booking.id),
                        child: const Text('Beri Ulasan'),
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }

  // Dialog untuk memberi ulasan
  void _showReviewDialog(BuildContext context, int bookingId) {
    final rating = 0.0.obs;
    final commentController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Beri Ulasan Anda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (value) {
                rating.value = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(labelText: 'Komentar Anda'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (rating.value > 0) {
                Get.back(); // Tutup dialog
                controller.postReview(
                  bookingId,
                  rating.value.toInt(),
                  commentController.text,
                );
              } else {
                Get.snackbar("Error", "Rating tidak boleh kosong.");
              }
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }
}
