import 'package:get/get.dart';

// Kelas ini akan mengelola data dan logika untuk Dashboard Babysitter.
// Untuk saat ini, kita akan membuatnya statis. Nanti kita akan hubungkan ke API.
class BabysitterDashboardController extends GetxController {
  // State untuk menyimpan nama babysitter
  var babysitterName = "Jessica (Contoh)".obs;

  // State untuk menyimpan daftar booking yang masuk
  var incomingBookings = <Map<String, String>>[
    {'name': 'April', 'time': '10:00 - 14:00'},
    {'name': 'Dea', 'time': '15:00 - 18:00'},
  ].obs;

  // State untuk jadwal hari ini
  var todaySchedule = "Menjaga bayi berusia 1 tahun (08:00 - 12:00)".obs;

  // State untuk ulasan terbaru
  var latestReview = {
    'name': 'Rita Sari',
    'comment': 'Sangat sabar dan perhatian, rekomendasi!',
    'rating': 5.0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    // Di masa depan, kita akan memanggil fungsi untuk mengambil data dari API di sini.
    // fetchDashboardData();
  }

  // Contoh fungsi untuk mengambil data dari API nantinya
  /*
  void fetchDashboardData() async {
    // Panggil service untuk GET /api/babysitter/dashboard
    // Lalu isi variabel-variabel di atas dengan data dari API.
  }
  */
}
