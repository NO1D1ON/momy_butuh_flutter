import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Controller untuk halaman pilih lokasi di peta
class MapPickerController extends GetxController {
  var isLoading = true.obs;

  // Posisi kamera awal (default Jakarta)
  final initialCameraPosition = const CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 12.0,
  );

  // Variabel untuk menyimpan controller Google Map setelah dibuat
  GoogleMapController? mapController;

  // State untuk menyimpan posisi pin yang dipilih pengguna
  var selectedPosition = Rxn<LatLng>();
  // State untuk menyimpan marker/pin di peta
  var markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Saat halaman dibuka, langsung coba dapatkan lokasi pengguna
    _determinePositionAndMoveCamera();
  }

  // Fungsi untuk mendapatkan lokasi terkini pengguna
  Future<void> _determinePositionAndMoveCamera() async {
    try {
      isLoading(true);
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw ('Izin lokasi ditolak oleh pengguna.');
        }
      }

      Position position = await Geolocator.getCurrentPosition();

      // Animasikan kamera ke lokasi pengguna
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15.0, // Zoom lebih dekat
        ),
      );
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fungsi yang dijalankan saat pengguna mengetuk peta
  void onMapTapped(LatLng position) {
    selectedPosition.value = position;
    markers.clear(); // Hapus pin lama
    // Tambahkan pin baru di lokasi yang diketuk
    markers.add(
      Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        infoWindow: const InfoWindow(title: 'Lokasi Penjagaan Dipilih'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    );
  }

  // Fungsi untuk mengkonfirmasi lokasi dan kembali ke halaman sebelumnya
  void confirmLocation() {
    if (selectedPosition.value != null) {
      // Kirim data koordinat kembali ke halaman sebelumnya
      Get.back(result: selectedPosition.value);
    } else {
      Get.snackbar(
        "Peringatan",
        "Silakan tandai lokasi terlebih dahulu dengan mengetuk peta.",
      );
    }
  }
}
