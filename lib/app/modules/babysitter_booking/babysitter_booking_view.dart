import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_booking/babysitter_booking_controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class BabysitterBookingsView extends GetView<BabysitterBookingsController> {
  const BabysitterBookingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Kita punya 2 tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Saya'),
          // Menggunakan PreferredSize untuk menempatkan TabBar di bawah AppBar
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                indicatorColor: AppTheme.primaryColor,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Riwayat Booking'),
                  Tab(text: 'Tawaran Terbuka'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Konten untuk Tab 1
            _buildMyBookingsList(),
            // Konten untuk Tab 2
            _buildJobOffersList(),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan daftar Riwayat Booking
  Widget _buildMyBookingsList() {
    return Obx(() {
      if (controller.isLoadingBookings.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final allBookingsEmpty =
          controller.upcomingBookings.isEmpty &&
          controller.completedBookings.isEmpty;
      if (allBookingsEmpty) {
        return const Center(
          child: Text("Anda belum memiliki riwayat booking."),
        );
      }
      // Gunakan ListView agar seluruh konten bisa di-scroll
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Akan Datang",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          controller.upcomingBookings.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Tidak ada pesanan akan datang.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Column(
                  children: controller.upcomingBookings.map((booking) {
                    return Card(
                      color: Color(0xFFFFF085),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => Get.toNamed(
                          Routes.PARENT_DETAIL,
                          arguments: booking,
                        ),
                        leading: const Icon(
                          Icons.calendar_month,
                          color: AppTheme.primaryColor,
                        ),
                        title: Text(
                          "Booking dari ${booking.parentName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${booking.parentAddress ?? 'Alamat tidak tersedia'}\n${DateFormat('d MMM y, HH:mm').format(booking.jobDate)}",
                          style: const TextStyle(height: 1.4),
                        ),
                        isThreeLine: true,
                        // --- PERBAIKAN LOGIKA TOMBOL ---
                        // Tombol konfirmasi sekarang ada di sini
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                          ),
                          onPressed: () =>
                              controller.confirmAsBabysitter(booking.id),
                          child: const Text(
                            'Selesaikan',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

          const SizedBox(height: 24),
          const Text(
            "Selesai",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          controller.completedBookings.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Tidak ada pesanan yang selesai.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Column(
                  children: controller.completedBookings.map((booking) {
                    return Card(
                      color: Colors.green.withOpacity(0.1),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => Get.toNamed(
                          Routes.PARENT_DETAIL,
                          arguments: booking,
                        ),
                        leading: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Booking dari ${booking.parentName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          DateFormat('d MMM y').format(booking.jobDate),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ],
      );
    });
  }

  // Widget untuk menampilkan daftar Penawaran Terbuka
  Widget _buildJobOffersList() {
    return Obx(() {
      if (controller.isLoadingOffers.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.jobOffers.isEmpty) {
        return const Center(
          child: Text("Tidak ada penawaran pekerjaan saat ini."),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.jobOffers.length,
        itemBuilder: (context, index) {
          final offer = controller.jobOffers[index];
          final initial = (offer.parentName.isNotEmpty)
              ? offer.parentName.substring(0, 1)
              : 'P';
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Text(initial)),
              title: Text(
                offer.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Oleh: Keluarga ${offer.parentName}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () =>
                  Get.toNamed(Routes.JOB_OFFER_DETAIL, arguments: offer.id),
            ),
          );
        },
      );
    });
  }
}
