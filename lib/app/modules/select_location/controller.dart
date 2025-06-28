import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momy_butuh_flutter/app/data/services/direction_service.dart';

class SelectLocationController extends GetxController {
  var isLoading = true.obs;
  var markers = <Marker>{}.obs; // Daftar penanda di peta
  var polylines = <Polyline>{}.obs; // Daftar rute di peta

  var currentPosition = Rxn<Position>(); // Posisi pengguna saat ini
  var selectedPosition = Rxn<LatLng>(); // Posisi yang dipilih pengguna

  // Posisi kamera awal (default Jakarta)
  final initialCameraPosition = const CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 12.0,
  );

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  // Fungsi untuk mendapatkan lokasi pengguna saat ini
  Future<void> _determinePosition() async {
    try {
      isLoading(true);
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw ('Izin lokasi ditolak.');
        }
      }
      currentPosition.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fungsi yang dipanggil saat peta diketuk
  void onMapTapped(LatLng position) {
    selectedPosition.value = position;
    markers.clear(); // Hapus marker lama
    markers.add(
      Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        infoWindow: const InfoWindow(title: 'Lokasi Dipilih'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    );
    polylines.clear(); // Hapus rute lama saat pin dipindahkan
  }

  // Fungsi untuk membuat rute
  void createDirections() async {
    if (currentPosition.value == null || selectedPosition.value == null) {
      Get.snackbar("Error", "Lokasi saat ini atau lokasi tujuan belum ada.");
      return;
    }

    final origin = LatLng(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
    );
    final destination = selectedPosition.value!;

    final points = await DirectionsService.getDirections(origin, destination);

    if (points.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ),
      );
    } else {
      Get.snackbar("Error", "Tidak dapat menemukan rute.");
    }
  }

  // Fungsi untuk mengkonfirmasi lokasi dan kembali ke halaman sebelumnya
  void confirmLocation() {
    if (selectedPosition.value != null) {
      Get.back(result: selectedPosition.value);
    } else {
      Get.snackbar("Peringatan", "Silakan tandai lokasi terlebih dahulu.");
    }
  }
}
