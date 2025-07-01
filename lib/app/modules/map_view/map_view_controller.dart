import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_availibility_model.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_available_service.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';

class MapViewController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var currentPosition = Rxn<Position>();

  GoogleMapController? mapController;
  var markers = <Marker>{}.obs;
  var initialCameraPosition = const CameraPosition(
    target: LatLng(3.601287045369116, 98.71801961534234), // Default Jakarta
    zoom: 17.0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocationAndFetchBabysitters();
  }

  /// Fungsi utama yang diperbarui untuk mengambil dan memfilter jadwal.
  Future<void> getCurrentLocationAndFetchBabysitters() async {
    try {
      isLoading(true);
      errorMessage.value = '';

      Position position = await _determinePosition();
      currentPosition.value = position;

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14.0,
        ),
      );

      final allNearbyAvailabilities =
          await BabysitterAvailabilityService.fetchAvailabilities();

      final now = DateTime.now();
      final todayDateString = DateFormat('yyyy-MM-dd').format(now);

      final activeBabysitters = allNearbyAvailabilities.where((avail) {
        if (avail.availableDate != todayDateString) {
          return false;
        }

        try {
          final startTime = DateFormat(
            "yyyy-MM-dd HH:mm:ss",
          ).parse("${avail.availableDate} ${avail.startTime}");
          var endTime = DateFormat(
            "yyyy-MM-dd HH:mm:ss",
          ).parse("${avail.availableDate} ${avail.endTime}");

          if (endTime.isBefore(startTime)) {
            endTime = endTime.add(const Duration(days: 1));
          }

          return now.isAfter(startTime) && now.isBefore(endTime);
        } catch (e) {
          print("Error parsing time for availability ID ${avail.id}: $e");
          return false;
        }
      }).toList();

      // --- MODIFIKASI: Mengirim posisi saat ini untuk membuat marker pengguna ---
      _createMarkers(activeBabysitters, position);

      if (activeBabysitters.isEmpty) {
        Get.snackbar(
          "Info",
          "Tidak ada babysitter yang sedang aktif di sekitar Anda saat ini.",
        );
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar("Error", errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  /// Fungsi untuk mendapatkan posisi (tidak ada perubahan)
  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        throw Exception('Izin lokasi ditolak.');
    }
    if (permission == LocationPermission.deniedForever)
      throw Exception('Izin lokasi ditolak permanen.');
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// --- MODIFIKASI: Nama fungsi diubah agar lebih umum ---
  /// Membuat marker untuk babysitter dan lokasi pengguna.
  void _createMarkers(
    List<BabysitterAvailability> availabilities,
    Position myPosition, // --- MODIFIKASI: Menerima posisi pengguna ---
  ) {
    var tempMarkers = <Marker>{};

    // --- TAMBAHAN: Membuat marker untuk lokasi pengguna ---
    tempMarkers.add(
      Marker(
        markerId: const MarkerId('my_location'),
        position: LatLng(myPosition.latitude, myPosition.longitude),
        infoWindow: const InfoWindow(title: 'Lokasi Saya'),
        // Menggunakan warna yang berbeda untuk membedakan
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );

    // Loop untuk membuat marker babysitter
    for (var avail in availabilities) {
      if (avail.latitude != null && avail.longitude != null) {
        final snippetText =
            "Rp ${NumberFormat('#,##0', 'id_ID').format(avail.ratePerHour)}/jam\nAktif: ${avail.startTime.substring(0, 5)} - ${avail.endTime.substring(0, 5)}";

        tempMarkers.add(
          Marker(
            markerId: MarkerId('avail-${avail.id}'),
            position: LatLng(avail.latitude!, avail.longitude!),
            infoWindow: InfoWindow(
              title: avail.name,
              snippet: snippetText,
              onTap: () {
                print(
                  "Marker Tapped! Navigating to detail for Babysitter ID: ${avail.babysitter.id}",
                );
                Get.toNamed(Routes.BABYSITTER_DETAIL, arguments: avail);
              },
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
      }
    }
    markers.value = tempMarkers;
  }
}
