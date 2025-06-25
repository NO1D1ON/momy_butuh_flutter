import 'package:get/get.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/favorite_service.dart';

class FavoriteController extends GetxController {
  var isLoading = true.obs;
  var favoriteList = <Babysitter>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil data saat halaman pertama kali dibuka
    fetchFavorites();
  }

  void fetchFavorites() async {
    try {
      isLoading(true);
      // Panggil method 'getFavorites' yang sudah kita buat
      var favorites = await FavoriteService.getFavorites();
      favoriteList.assignAll(favorites);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
