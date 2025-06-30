import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momy_butuh_flutter/app/modules/map_view/map_view_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class MapView extends GetView<MapViewController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Get.back(), // Perintah GetX untuk kembali ke halaman sebelumnya.
        ),
        centerTitle: false,
        titleSpacing: 0,

        title: const Text(
          'Cari Babysitter Terdekat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.getCurrentLocationAndFetchBabysitters(),
          ),
        ],
      ),
      body: Obx(() {
        // Jika ada error, tampilkan pesan error
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text("Error: ${controller.errorMessage.value}"));
        }

        // Tampilkan peta dengan marker yang sudah dinamis
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: controller.initialCameraPosition.value,
          onMapCreated: (mapCtrl) => controller.mapController = mapCtrl,
          markers: controller.markers.value, // <-- Ambil marker dari controller
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      }),
    );
  }
}
