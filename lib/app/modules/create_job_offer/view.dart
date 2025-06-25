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
      appBar: AppBar(title: const Text('Buat Penawaran Pekerjaan')),
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
            // Input untuk Tanggal & Waktu
            // ...
            // Tombol untuk memilih lokasi di peta
            OutlinedButton.icon(
              onPressed: () async {
                // Navigasi ke halaman peta dan tunggu hasilnya
                var result = await Get.toNamed(Routes.SELECT_LOCATION);
                if (result is LatLng) {
                  // Jika pengguna memilih lokasi, tampilkan di controller
                  controller.updateLocation(result);
                }
              },
              icon: const Icon(Icons.location_on_outlined),
              label: const Text("Pilih Lokasi di Peta"),
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
