import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/topup/topup_controller.dart';

class TopupView extends GetView<TopupController> {
  const TopupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Up Saldo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ... (Widget Instruksi)
            const SizedBox(height: 24),
            TextField(controller: controller.amountController /* ... */),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.pickedFile.value == null) {
                return OutlinedButton.icon(
                  onPressed: () => controller.pickImage(),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Pilih Bukti Pembayaran"),
                );
              } else {
                return Column(
                  children: [
                    const Text("Bukti Pembayaran:"),
                    const SizedBox(height: 8),
                    kIsWeb
                        ? Image.network(
                            controller.pickedFile.value!.path,
                            height: 200,
                          )
                        : Image.file(
                            File(controller.pickedFile.value!.path),
                            height: 200,
                          ),
                    TextButton(
                      onPressed: () => controller.pickImage(),
                      child: const Text("Ganti Gambar"),
                    ),
                  ],
                );
              }
            }),
            const SizedBox(height: 32),
            // Tombol Konfirmasi
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitTopup(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text("Konfirmasi Top Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
