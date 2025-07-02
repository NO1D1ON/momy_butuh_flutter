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

  // Variabel untuk menyimpan custom marker icons
  BitmapDescriptor? userLocationIcon;
  BitmapDescriptor? babysitterIcon;
  BitmapDescriptor? activeBabysitterIcon;

  @override
  void onInit() {
    super.onInit();
    _loadCustomMarkers();
    getCurrentLocationAndFetchBabysitters();
  }

  /// Load custom marker icons
  Future<void> _loadCustomMarkers() async {
    try {
      // Custom icon untuk lokasi user (lingkaran biru)
      userLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/icons/pin.png', // Ganti dengan path asset Anda
      );

      // Custom icon untuk babysitter (ikon orang/baby)
      babysitterIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/icons/smile.png', // Ganti dengan path asset Anda
      );

      // Custom icon untuk babysitter aktif (ikon orang/baby dengan status aktif)
      activeBabysitterIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/icons/smile.png', // Ganti dengan path asset Anda
      );
    } catch (e) {
      print("Error loading custom markers: $e");
      // Fallback ke default markers jika custom icons gagal dimuat
      _setDefaultMarkers();
    }
  }

  /// Set default marker colors sebagai fallback
  void _setDefaultMarkers() {
    userLocationIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    );
    babysitterIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueOrange,
    );
    activeBabysitterIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
    );
  }

  /// Fungsi utama yang diperbarui untuk mengambil dan memfilter jadwal.
  Future<void> getCurrentLocationAndFetchBabysitters() async {
    try {
      isLoading(true);
      errorMessage.value = '';

      Position position = await _determinePosition();
      currentPosition.value = position;

      // Update camera position
      initialCameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

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

      // Ambil semua babysitter (termasuk yang tidak aktif)
      final allBabysitters = allNearbyAvailabilities.where((avail) {
        return avail.latitude != null && avail.longitude != null;
      }).toList();

      // Buat markers dengan posisi pengguna
      _createMarkers(allBabysitters, activeBabysitters, position);

      if (activeBabysitters.isEmpty) {
        Get.snackbar(
          "Info",
          "Tidak ada babysitter yang sedang aktif di sekitar Anda saat ini.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  /// Membuat marker dengan jenis yang berbeda-beda
  void _createMarkers(
    List<BabysitterAvailability> allBabysitters,
    List<BabysitterAvailability> activeBabysitters,
    Position myPosition,
  ) {
    var tempMarkers = <Marker>{};

    // Marker untuk lokasi pengguna dengan icon khusus
    tempMarkers.add(
      Marker(
        markerId: const MarkerId('my_location'),
        position: LatLng(myPosition.latitude, myPosition.longitude),
        infoWindow: const InfoWindow(
          title: '📍 Lokasi Saya',
          snippet: 'Posisi Anda saat ini',
        ),
        icon:
            userLocationIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Set untuk menyimpan ID babysitter yang aktif
    final activeBabysitterIds = activeBabysitters
        .map((avail) => avail.babysitter.id)
        .toSet();

    // Loop untuk membuat marker babysitter
    for (var avail in allBabysitters) {
      if (avail.latitude != null && avail.longitude != null) {
        final isActive = activeBabysitterIds.contains(avail.babysitter.id);

        // Format harga dengan currency Indonesia
        final formattedRate = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(avail.ratePerHour);

        final status = isActive ? "🟢 Sedang Aktif" : "🔴 Tidak Aktif";
        final timeInfo =
            "${avail.startTime.substring(0, 5)} - ${avail.endTime.substring(0, 5)}";

        final snippetText = "$formattedRate/jam\n$status\nJadwal: $timeInfo";

        // Pilih icon berdasarkan status
        BitmapDescriptor markerIcon;
        if (isActive) {
          markerIcon =
              activeBabysitterIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        } else {
          markerIcon =
              babysitterIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
        }

        tempMarkers.add(
          Marker(
            markerId: MarkerId('avail-${avail.id}'),
            position: LatLng(avail.latitude!, avail.longitude!),
            infoWindow: InfoWindow(
              title: "${isActive ? '👶' : '💤'} ${avail.name}",
              snippet: snippetText,
              onTap: () {
                print(
                  "Marker Tapped! Navigating to detail for Babysitter ID: ${avail.babysitter.id}",
                );
                Get.toNamed(Routes.BABYSITTER_DETAIL, arguments: avail);
              },
            ),
            icon: markerIcon,
            // Tambahkan alpha untuk babysitter yang tidak aktif
            alpha: isActive ? 1.0 : 0.7,
          ),
        );
      }
    }

    markers.value = tempMarkers;
    print("Total markers created: ${tempMarkers.length}");
  }

  /// Method untuk refresh data
  void refreshData() {
    getCurrentLocationAndFetchBabysitters();
  }

  /// Method untuk zoom ke lokasi pengguna
  void zoomToMyLocation() {
    if (currentPosition.value != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
          16.0,
        ),
      );
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
