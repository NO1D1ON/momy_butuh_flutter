import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_service.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';

class MapViewController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var currentPosition = Rxn<Position>();

  GoogleMapController? mapController;
  var markers = <Marker>{}.obs;
  var initialCameraPosition = const CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 12.0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocationAndFetchBabysitters();
  }

  /// Fungsi utama
  Future<void> getCurrentLocationAndFetchBabysitters() async {
    try {
      isLoading(true);
      errorMessage.value = '';

      // ✅ Gunakan fungsi baru yang mengembalikan Position
      Position position = await getCurrentPosition();
      currentPosition.value = position;

      // Gerakkan kamera ke lokasi pengguna
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14.0,
        ),
      );

      // Ambil data babysitter
      final babysitters = await BabysitterService.fetchNearbyBabysitters(
        position.latitude,
        position.longitude,
      );

      if (babysitters.isEmpty) {
        Get.snackbar(
          "Info",
          "Tidak ada babysitter yang ditemukan di sekitar Anda saat ini.",
        );
        return;
      }

      _createMarkers(babysitters);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar("Error", errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  /// ✅ Fungsi baru yang mengembalikan Position
  Future<Position> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Izin lokasi ditolak secara permanen. Silakan aktifkan di pengaturan.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }

  /// (Opsional) Jika dipanggil untuk hanya menggeser kamera ke posisi saat ini
  Future<void> determinePositionAndMoveCamera() async {
    try {
      Position position = await getCurrentPosition();
      currentPosition.value = position;

      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15.0,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
      Get.snackbar(
        "Error Lokasi",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  /// Marker builder
  void _createMarkers(List<Babysitter> babysitters) {
    var tempMarkers = <Marker>{};
    for (var babysitter in babysitters) {
      if (babysitter.latitude != null && babysitter.longitude != null) {
        tempMarkers.add(
          Marker(
            markerId: MarkerId(babysitter.id.toString()),
            position: LatLng(babysitter.latitude!, babysitter.longitude!),
            infoWindow: InfoWindow(
              title: babysitter.name,
              snippet:
                  "Rp ${babysitter.ratePerHour}/jam - Rating: ${babysitter.rating}",
              onTap: () {
                Get.toNamed(Routes.BABYSITTER_DETAIL, arguments: babysitter.id);
              },
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRose,
            ),
          ),
        );
      }
    }
    markers.value = tempMarkers;
  }
}
