import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/services/parent_profile_service.dart';
import 'package:momy_butuh_flutter/app/data/services/user_profile_model.dart';

class ParentDetailController extends GetxController {
  final int parentId = Get.arguments; // Mengambil ID dari halaman sebelumnya
  var isLoading = true.obs;
  var parentProfile = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  void fetchDetails() async {
    try {
      isLoading(true);
      var result = await ParentProfileService.fetchParentProfile(parentId);
      parentProfile.value = result;
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading(false);
    }
  }
}
