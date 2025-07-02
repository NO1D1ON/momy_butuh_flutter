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
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Cari Babysitter Terdekat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshData(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () => controller.zoomToMyLocation(),
            tooltip: 'Lokasi Saya',
          ),
        ],
      ),
      body: Obx(() {
        // Jika sedang loading, tampilkan indicator
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Mencari babysitter terdekat...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Jika ada error, tampilkan pesan error
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  "Error: ${controller.errorMessage.value}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        // Tampilkan peta dengan marker yang sudah dinamis
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: controller.initialCameraPosition.value,
              onMapCreated: (mapCtrl) => controller.mapController = mapCtrl,
              markers: controller.markers.value,
              myLocationEnabled:
                  false, // Dinonaktifkan karena kita punya custom marker
              myLocationButtonEnabled:
                  false, // Dinonaktifkan karena kita punya tombol custom
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
              compassEnabled: true,
              tiltGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
            ),
            // Legend/Keterangan marker
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Keterangan:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildLegendItem('📍', 'Lokasi Anda', Colors.blue),
                    _buildLegendItem('👶', 'Babysitter Aktif', Colors.green),
                    _buildLegendItem('💤', 'Babysitter Offline', Colors.orange),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLegendItem(String emoji, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
