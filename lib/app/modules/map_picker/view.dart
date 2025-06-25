import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momy_butuh_flutter/app/modules/map_picker/controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class MapPickerView extends GetView<MapPickerController> {
  const MapPickerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi Penjagaan'),
        actions: [
          // Tombol "Pilih" di AppBar untuk konfirmasi
          TextButton(
            onPressed: controller.confirmLocation,
            child: const Text(
              "PILIH",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return GoogleMap(
          // Panggil method onMapTapped dari controller saat peta diketuk
          onTap: controller.onMapTapped,
          // Ambil daftar marker dari controller
          markers: controller.markers.value,
          mapType: MapType.normal,
          initialCameraPosition: controller.initialCameraPosition,
          // Simpan instance GoogleMapController ke dalam controller kita
          onMapCreated: (GoogleMapController mapCtrl) {
            controller.mapController = mapCtrl;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      }),
    );
  }
}
