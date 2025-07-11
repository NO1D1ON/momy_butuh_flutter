import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momy_butuh_flutter/app/modules/create_job_offer/controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class CreateJobOfferView extends GetView<CreateJobOfferController> {
  const CreateJobOfferView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Buat Penawaran Pekerjaan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Widget sapaan di bagian atas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Publikasikan kebutuhan Anda dan biarkan babysitter terbaik menemukan Anda!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.titleC,
              decoration: const InputDecoration(
                labelText: "Judul Pekerjaan",
                hintText: "cth: Butuh Babysitter untuk Akhir Pekan",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.descriptionC,
              decoration: const InputDecoration(
                labelText: "Deskripsi Kebutuhan",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.priceC,
              decoration: const InputDecoration(
                labelText: "Harga yang Ditawarkan (Total)",
                prefixText: "Rp ",
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            // --- TAMBAHAN INPUT TANGGAL & WAKTU ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.dateC,
                    readOnly: true, // Agar tidak bisa diketik manual
                    decoration: const InputDecoration(
                      labelText: "Tanggal Pekerjaan",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => controller.pickDate(), // Panggil date picker
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                    onTap: () =>
                        controller.pickTime(true), // Panggil time picker
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
                    onTap: () =>
                        controller.pickTime(false), // Panggil time picker
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Input untuk Tanggal & Waktu
            // ...
            // Tombol untuk memilih lokasi di peta
            TextField(
              controller: controller.addressC,
              decoration: const InputDecoration(
                labelText: "Alamat Lokasi Pekerjaan",
                hintText: "Pilih lokasi dari peta",
              ),
              // Buat readOnly agar pengguna disarankan menggunakan tombol peta
              readOnly: true,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            // Tombol untuk memilih lokasi di peta
            OutlinedButton.icon(
              onPressed: () async {
                // Navigasi ke halaman peta dan tunggu hasilnya
                var result = await Get.toNamed(Routes.SELECT_LOCATION);

                // Cek jika hasil adalah Map, bukan lagi LatLng
                if (result is Map<String, dynamic>) {
                  // Panggil method updateLocation yang baru dengan hasil Map
                  controller.updateLocation(result);
                }
              },
              icon: const Icon(Icons.location_on_outlined),
              label: const Text("Pilih atau Ubah Lokasi di Peta"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => controller.submitOffer(),
              child: const Text("Publikasikan Penawaran"),
            ),
          ],
        ),
      ),
    );
  }
}
