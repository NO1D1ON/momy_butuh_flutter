import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/favorite/controllers/favorite_controller.dart';

class BabysitterFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan BabysitterFavoriteController saat rute dipanggil
    Get.lazyPut<FavoriteController>(() => FavoriteController());
  }
}
