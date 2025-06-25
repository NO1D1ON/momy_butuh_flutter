import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_service.dart';

class MapViewController extends GetxController {
  var isLoading = true.obs;
  var markers = <Marker>{}.obs; // Set of markers
  var initialCameraPosition = const CameraPosition(
    target: LatLng(-6.2088, 106.8456), // Default: Jakarta
    zoom: 14.0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocationAndFetchBabysitters();
  }

  Future<void> getCurrentLocationAndFetchBabysitters() async {
    try {
      isLoading(true);
      // Minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Izin lokasi ditolak.");
          return;
        }
      }

      // Dapatkan posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update posisi kamera ke lokasi pengguna
      initialCameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

      // Ambil data babysitter terdekat dari API
      final babysitters = await BabysitterService.fetchNearbyBabysitters(
        position.latitude,
        position.longitude,
      );

      // Buat marker untuk setiap babysitter
      var tempMarkers = <Marker>{};
      for (var babysitter in babysitters) {
        // Asumsikan babysitter punya lat & lon, jika tidak, lewati
        // Anda perlu menambahkan latitude dan longitude di model dan API Laravel
        // double lat = double.tryParse(babysitter.latitude ?? '0') ?? 0;
        // double lon = double.tryParse(babysitter.longitude ?? '0') ?? 0;

        // Untuk sekarang kita gunakan posisi acak di sekitar pengguna
        // Gantilah ini dengan data asli dari API Anda
        tempMarkers.add(
          Marker(
            markerId: MarkerId(babysitter.id.toString()),
            position: LatLng(
              position.latitude + (babysitter.id % 2 == 0 ? 0.005 : -0.005),
              position.longitude + (babysitter.id % 3 == 0 ? 0.005 : -0.005),
            ),
            infoWindow: InfoWindow(
              title: babysitter.name,
              snippet: "Rp ${babysitter.ratePerHour}/jam",
            ),
          ),
        );
      }
      markers.value = tempMarkers;
    } catch (e) {
      Get.snackbar("Error Lokasi", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
