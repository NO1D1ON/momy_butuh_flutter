import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_dashboard/babysitter_dashboard_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

// Tampilan untuk Dashboard Babysitter
class BabysitterDashboardView extends GetView<BabysitterDashboardController> {
  const BabysitterDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Halo, ${controller.babysitterName.value}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian Notifikasi Booking ---
            const Text(
              "Booking Masuk",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children: controller.incomingBookings
                    .map(
                      (booking) => _buildBookingCard(
                        name: booking['name']!,
                        time: booking['time']!,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // --- Bagian Jadwal Tugas ---
            const Text(
              "Jadwal Tugas Hari Ini",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => Text(
                    controller.todaySchedule.value,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Bagian Ulasan Terbaru ---
            const Text(
              "Ulasan Terbaru",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(child: Text("RS")),
                title: Obx(
                  () => Text(
                    controller.latestReview['name'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Obx(
                  () => Text(controller.latestReview['comment'].toString()),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Obx(
                      () => Text(controller.latestReview['rating'].toString()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat kartu notifikasi booking
  Widget _buildBookingCard({required String name, required String time}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.person, color: AppTheme.primaryColor),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Aksi saat notifikasi di-klik
        },
      ),
    );
  }
}
