import 'package:get/get.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/favorite_service.dart';

class FavoriteController extends GetxController {
  var isLoading = true.obs;
  var favoriteList = <Babysitter>[].obs;

  // onInit dipanggil setiap kali halaman ini dibuka
  @override
  void onInit() {
    super.onInit();
    // Selalu ambil data terbaru saat halaman favorit diakses
    fetchFavorites();
  }

  /// Mengambil daftar lengkap babysitter favorit dari server
  Future<void> fetchFavorites() async {
    try {
      isLoading(true);
      var result = await FavoriteService.getFavorites();
      favoriteList.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar favorit: ${e.toString()}');
      // Pastikan list kosong jika terjadi error
      favoriteList.clear();
    } finally {
      isLoading(false);
    }
  }

  /// Fungsi untuk menghapus favorit langsung dari halaman ini
  void removeFromFavorites(int babysitterId) async {
    // Optimistic UI: Langsung hapus dari list agar UI responsif
    favoriteList.removeWhere((babysitter) => babysitter.id == babysitterId);

    // Kirim request ke server di background
    var result = await FavoriteService.toggleFavorite(babysitterId);

    // Jika gagal, tampilkan pesan dan muat ulang data agar konsisten
    if (!result['success']) {
      Get.snackbar('Gagal', 'Gagal menghapus favorit. Memuat ulang...');
      fetchFavorites();
    } else {
      Get.snackbar('Info', 'Babysitter dihapus dari favorit.');
    }
  }
}
