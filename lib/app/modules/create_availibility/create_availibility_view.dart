import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/create_availibility/create_avavilibility_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class CreateAvailabilityView extends GetView<CreateAvailabilityController> {
  const CreateAvailabilityView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tawarkan Jadwal Anda')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Tentukan jadwal dan tarif Anda. Biarkan orang tua menemukan Anda!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 24),

            // Input Tanggal
            TextField(
              controller: controller.dateC,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Tanggal Tersedia",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => controller.pickDate(),
            ),
            const SizedBox(height: 16),

            // Input Jam Mulai & Selesai
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.startTimeC,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Jam Mulai",
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () => controller.pickTime(true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: controller.endTimeC,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Jam Selesai",
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () => controller.pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Input Tarif per Jam
            TextField(
              controller: controller.rateC,
              decoration: const InputDecoration(
                labelText: "Tarif per Jam",
                prefixText: "Rp ",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Input Lokasi (diisi otomatis)
            TextField(
              controller: controller.locationC,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Lokasi Saya",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => controller.getCurrentLocation(),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Input Bio/Catatan
            TextField(
              controller: controller.notesC,
              decoration: const InputDecoration(
                labelText: "Catatan atau Bio Singkat (Opsional)",
                hintText:
                    "cth: Bersedia bekerja di akhir pekan, berpengalaman dengan balita.",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Tombol Submit
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitAvailability(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text("Publikasikan Jadwal"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
