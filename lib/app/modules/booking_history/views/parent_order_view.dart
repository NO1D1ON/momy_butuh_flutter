import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/booking_history/controllers/parent_booking_controller.dart';
import '../../../utils/theme.dart';

class ParentOrdersView extends GetView<ParentOrdersController> {
  const ParentOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Kita punya 2 tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Saya'),
          backgroundColor: Colors.white,
          elevation: 1,
          bottom: const TabBar(
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Riwayat Booking'),
              Tab(text: 'Tawaran Saya'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- Konten Tab 1: Riwayat Booking ---
            _buildMyBookingsList(),

            // --- Konten Tab 2: Tawaran Saya ---
            _buildMyJobOffersList(),
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
      if (controller.myBookings.isEmpty) {
        return const Center(
          child: Text("Anda belum memiliki riwayat booking."),
        );
      }
      // Di sini Anda bisa gunakan ListView untuk menampilkan data dari controller.myBookings
      return ListView.builder(
        itemCount: controller.myBookings.length,
        itemBuilder: (context, index) {
          final booking = controller.myBookings[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text("Booking dengan ${booking.babysitterName}"),
              subtitle: Text("Tanggal: ${booking.bookingDate}"),
              trailing: Text(
                booking.status,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      );
    });
  }

  // Widget untuk menampilkan daftar Penawaran Saya
  Widget _buildMyJobOffersList() {
    return Obx(() {
      if (controller.isLoadingOffers.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.myJobOffers.isEmpty) {
        return const Center(child: Text("Anda belum membuat penawaran."));
      }
      // Di sini Anda bisa gunakan ListView untuk menampilkan data dari controller.myJobOffers
      return ListView.builder(
        itemCount: controller.myJobOffers.length,
        itemBuilder: (context, index) {
          final offer = controller.myJobOffers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(offer.title),
              subtitle: Text("Status: ${offer.status}"),
              trailing: Text("Rp ${offer.offeredPrice}"),
            ),
          );
        },
      );
    });
  }
}
