import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momy_butuh_flutter/app/data/services/topup_service.dart';

class TopupController extends GetxController {
  final amountController = TextEditingController();
  var isLoading = false.obs;
  var pickedFile = Rxn<XFile>();

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedFile.value = image;
    }
  }

  void submitTopup() async {
    if (amountController.text.isEmpty || pickedFile.value == null) {
      Get.snackbar(
        "Error",
        "Jumlah top up dan bukti bayar tidak boleh kosong.",
      );
      return;
    }

    isLoading.value = true;
    try {
      final imageBytes = await pickedFile.value!.readAsBytes();
      final fileName = pickedFile.value!.name;

      bool success = await TopupService.submitTopup(
        imageBytes: imageBytes,
        fileName: fileName,
        amount: amountController.text,
      );

      isLoading.value = false;
      AwesomeDialog(
        context: Get.context!,
        dialogType: success ? DialogType.success : DialogType.error,
        title: success ? 'Berhasil' : 'Gagal',
        desc: success
            ? 'Permintaan top up Anda telah diajukan.'
            : 'Gagal mengajukan top up.',
        btnOkOnPress: () {
          if (success) Get.back();
        },
      ).show();
    } catch (e) {
      isLoading(false);
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: "Error",
        desc: e.toString(),
      ).show();
    }
  }
}
