// import 'package:get/get.dart';
// import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
// import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
// // Import model dan service yang relevan

// class BabysitterOrdersController extends GetxController {
//   // Controller ini akan mengelola state untuk kedua tab
//   var upcomingBookings = <Booking>[].obs; // Data dari API
//   var completedBookings = <Booking>[].obs; // Data dari API
//   var jobOffers = <JobOffer>[].obs; // Data dari API
//   var isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchData();
//   }

//   void fetchData() async {
//     try {
//       isLoading(true);
//       // Panggil semua API yang dibutuhkan secara bersamaan
//       await Future.wait([fetchMyBookings(), fetchJobOffers()]);
//     } finally {
//       isLoading(false);
//     }
//   }

//   // ... (Method fetchMyBookings dan fetchJobOffers akan memanggil service masing-masing)
// }
