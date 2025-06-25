import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momy_butuh_flutter/app/modules/select_location/controller.dart';

class SelectLocationView extends GetView<SelectLocationController> {
  const SelectLocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi di Peta'),
        actions: [
          // Tombol konfirmasi di AppBar
          TextButton(
            onPressed: () => controller.confirmLocation(),
            child: const Text(
              "PILIH",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              // Posisikan kamera ke lokasi pengguna jika ada, jika tidak gunakan default
              initialCameraPosition: controller.currentPosition.value != null
                  ? CameraPosition(
                      target: LatLng(
                        controller.currentPosition.value!.latitude,
                        controller.currentPosition.value!.longitude,
                      ),
                      zoom: 14.0,
                    )
                  : controller.initialCameraPosition,
              onTap: controller.onMapTapped,
              markers: controller.markers.value,
              polylines: controller.polylines.value,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            // Tampilkan tombol "Buat Rute" hanya jika lokasi sudah dipilih
            if (controller.selectedPosition.value != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton.icon(
                  onPressed: () => controller.createDirections(),
                  icon: const Icon(Icons.directions),
                  label: const Text("Tampilkan Rute"),
                ),
              ),
          ],
        );
      }),
    );
  }
}
