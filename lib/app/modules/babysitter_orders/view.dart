// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:momy_butuh_flutter/app/modules/babysitter_orders/controller.dart';
// import 'package:momy_butuh_flutter/app/utils/theme.dart';

// class BabysitterOrdersView extends GetView<BabysitterOrdersController> {
//   const BabysitterOrdersView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Kita punya 2 tab
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Pesanan Saya'),
//           bottom: const TabBar(
//             indicatorColor: AppTheme.primaryColor,
//             labelColor: AppTheme.primaryColor,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               Tab(text: 'Riwayat Booking'),
//               Tab(text: 'Tawaran Terbuka'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // --- Tab 1: Riwayat Booking ---
//             Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               // Buat widget ListView untuk menampilkan booking yang akan datang dan yang selesai
//               return _buildBookingList();
//             }),

//             // --- Tab 2: Tawaran Terbuka ---
//             Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               // Buat widget ListView untuk menampilkan job offers
//               return _buildJobOfferList();
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget untuk menampilkan daftar booking (Anda bisa memindahkannya ke file terpisah)
//   Widget _buildBookingList() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         const Text(
//           "Akan Datang",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         // Card untuk booking yang akan datang (warna tema)
//         Card(
//           color: AppTheme.primaryColor.withOpacity(0.15),
//           child: const ListTile(
//             leading: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
//             title: Text(
//               "Booking dari Rita Sari",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text("27 Juni 2025 - 09:00-12:00"),
//           ),
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           "Selesai",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         // Card untuk booking yang sudah selesai (warna hijau)
//         Card(
//           color: Colors.green.withOpacity(0.15),
//           child: const ListTile(
//             leading: Icon(Icons.check_circle, color: Colors.green),
//             title: Text(
//               "Booking dari Budi",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text("20 Juni 2025 - 13:00-17:00"),
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget untuk menampilkan daftar penawaran pekerjaan
//   Widget _buildJobOfferList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: 5, // Ganti dengan controller.jobOffers.length
//       itemBuilder: (context, index) {
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             leading: const CircleAvatar(child: Text("OP")),
//             title: const Text(
//               "Butuh Cepat untuk Jaga Anak",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: const Text("Keluarga Budi - Medan Amplas"),
//             trailing: const Icon(Icons.arrow_forward_ios, size: 14),
//             onTap: () {
//               // Navigasi ke detail penawaran
//             },
//           ),
//         );
//       },
//     );
//   }
// }
