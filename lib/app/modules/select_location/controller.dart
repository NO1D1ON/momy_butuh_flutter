import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:momy_butuh_flutter/app/data/services/direction_service.dart';

class SelectLocationController extends GetxController {
  var isLoading = true.obs;
  var markers = <Marker>{}.obs; // Daftar penanda di peta
  var polylines = <Polyline>{}.obs; // Daftar rute di peta

  var currentPosition = Rxn<Position>(); // Posisi pengguna saat ini
  var selectedPosition = Rxn<LatLng>(); // Posisi yang dipilih pengguna

  // Controller untuk Google Map
  GoogleMapController? mapController;
  // Controller untuk kolom pencarian
  TextEditingController searchController = TextEditingController();

  // State untuk menyimpan hasil pilihan
  var selectedPlaceName = ''.obs;
  var isGeocoding = false.obs;

  // Posisi kamera awal (default Medan, sesuai lokasi Anda)
  final initialCameraPosition = const CameraPosition(
    target: LatLng(3.579212785850644, 98.644330499191),
    zoom: 12.0,
  );

  @override
  void onInit() {
    super.onInit();
    determinePositionAndMoveCamera();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fungsi untuk mendapatkan lokasi pengguna saat ini
  Future<void> determinePositionAndMoveCamera() async {
    try {
      isLoading(true);
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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

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
    } finally {
      isLoading(false);
    }
  }

  void onMapTapped(LatLng position) async {
    // Validasi input koordinat
    if (position.latitude < -90 ||
        position.latitude > 90 ||
        position.longitude < -180 ||
        position.longitude > 180) {
      Get.snackbar("Error", "Koordinat tidak valid");
      return;
    }

    selectedPosition.value = position;
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        infoWindow: const InfoWindow(title: 'Lokasi Dipilih'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    );

    // Tampilkan loading dan kosongkan teks alamat lama
    isGeocoding.value = true;
    searchController.text = "Mencari nama alamat...";

    try {
      // Panggil reverse geocoding dengan timeout
      List<Placemark> placemarks =
          await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
            // localeIdentifier: 'id_ID', // Set locale ke Indonesia
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout saat mencari alamat');
            },
          );

      // PASTIKAN hasil tidak kosong sebelum diakses
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Format alamat dengan pengecekan null safety yang lebih baik
        String address = _buildAddressString(place);

        searchController.text = address.isNotEmpty
            ? address
            : "Alamat tidak tersedia untuk lokasi ini";

        selectedPlaceName.value = address;
      } else {
        // Jika tidak ada alamat ditemukan, berikan pesan
        searchController.text = "Tidak ada alamat ditemukan untuk lokasi ini.";
        selectedPlaceName.value = "Lokasi Tidak Dikenal";
      }
    } catch (e) {
      debugPrint("Error Geocoding: $e");
      String errorMessage = "Gagal mendapatkan nama alamat.";

      // Berikan pesan error yang lebih spesifik
      if (e.toString().contains('network')) {
        errorMessage = "Tidak ada koneksi internet untuk mendapatkan alamat.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Timeout saat mencari alamat. Coba lagi.";
      }

      searchController.text = errorMessage;
      selectedPlaceName.value = "Error: ${e.toString()}";

      Get.snackbar(
        "Error Geocoding",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      // Pastikan loading selalu berhenti
      isGeocoding.value = false;
    }
  }

  // Helper method untuk membangun string alamat dengan null safety
  String _buildAddressString(Placemark place) {
    List<String> addressParts = [];

    // Tambahkan komponen alamat yang tidak null dan tidak kosong
    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      addressParts.add(place.subAdministrativeArea!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }

    // Jika tidak ada komponen alamat yang valid, gunakan informasi dasar
    if (addressParts.isEmpty) {
      if (place.name != null && place.name!.isNotEmpty) {
        addressParts.add(place.name!);
      }
      if (place.country != null && place.country!.isNotEmpty) {
        addressParts.add(place.country!);
      }
    }

    return addressParts.isNotEmpty
        ? addressParts.join(', ')
        : 'Lat: ${selectedPosition.value?.latitude.toStringAsFixed(6)}, Lng: ${selectedPosition.value?.longitude.toStringAsFixed(6)}';
  }

  // Fungsi yang diperbaiki untuk menangani Prediction
  void goToPlace(Prediction prediction) {
    try {
      // Validasi prediction object
      if (prediction.lat == null || prediction.lng == null) {
        Get.snackbar("Error", "Data lokasi tidak lengkap");
        return;
      }

      // Ambil lat dan lng dari prediction.lat dan prediction.lng
      final latString = prediction.lat!;
      final lngString = prediction.lng!;

      final lat = double.tryParse(latString);
      final lng = double.tryParse(lngString);

      if (lat != null && lng != null) {
        // Validasi koordinat
        if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
          Get.snackbar("Error", "Koordinat tidak valid");
          return;
        }

        final latLng = LatLng(lat, lng);

        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(latLng, 16.0),
          );
          onMapTapped(latLng);

          // Update search controller dengan deskripsi tempat jika ada
          if (prediction.description != null &&
              prediction.description!.isNotEmpty) {
            // Simpan teks sementara karena onMapTapped akan mengubahnya
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!isGeocoding.value) {
                searchController.text = prediction.description!;
              }
            });
          }
        }
      } else {
        Get.snackbar("Error", "Format koordinat tidak valid");
      }
    } catch (e) {
      debugPrint("Error in goToPlace: $e");
      Get.snackbar("Error", "Gagal menuju lokasi: ${e.toString()}");
    }
  }

  void confirmLocation() {
    if (selectedPosition.value != null) {
      // Pastikan ada alamat yang valid
      String finalAddress =
          searchController.text.isNotEmpty &&
              !searchController.text.contains("Mencari") &&
              !searchController.text.contains("Gagal")
          ? searchController.text
          : 'Lokasi dari Peta (${selectedPosition.value!.latitude.toStringAsFixed(6)}, ${selectedPosition.value!.longitude.toStringAsFixed(6)})';

      Get.back(
        result: {
          'latlng': selectedPosition.value,
          'address': finalAddress,
          'latitude': selectedPosition.value!.latitude,
          'longitude': selectedPosition.value!.longitude,
        },
      );
    } else {
      Get.snackbar(
        "Peringatan",
        "Silakan tandai lokasi di peta terlebih dahulu.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  // Tambahan: Method untuk retry geocoding jika gagal
  void retryGeocoding() {
    if (selectedPosition.value != null) {
      onMapTapped(selectedPosition.value!);
    }
  }

  // Tambahan: Method untuk menggunakan lokasi saat ini
  void useCurrentLocation() async {
    if (currentPosition.value != null) {
      final currentLatLng = LatLng(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );

      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 16.0),
        );
      }

      onMapTapped(currentLatLng);
    } else {
      await determinePositionAndMoveCamera();
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:momy_butuh_flutter/app/data/services/location_search_services.dart';
// import 'dart:async';

// class SelectLocationController extends GetxController {
//   GoogleMapController? mapController;
//   TextEditingController searchController = TextEditingController();

//   var isLoading = true.obs;
//   var markers = <Marker>{}.obs;
//   var selectedPosition = Rxn<LatLng>();

//   // State baru untuk hasil pencarian
//   var searchResults = <dynamic>[].obs;
//   var isSearching = false.obs;
//   Timer? _debounce;

//   final initialCameraPosition = const CameraPosition(
//     target: LatLng(-6.2088, 106.8456),
//     zoom: 12.0,
//   );

//   @override
//   void onInit() {
//     super.onInit();
//     determinePositionAndMoveCamera();
//     // Tambahkan listener untuk mendeteksi ketikan di kolom pencarian
//     searchController.addListener(() {
//       if (_debounce?.isActive ?? false) _debounce!.cancel();
//       _debounce = Timer(const Duration(milliseconds: 800), () {
//         if (searchController.text.length > 2) {
//           performSearch(searchController.text);
//         } else {
//           searchResults.clear();
//         }
//       });
//     });
//   }

//   @override
//   void onClose() {
//     _debounce?.cancel();
//     searchController.dispose();
//     super.onClose();
//   }

//   Future<void> determinePositionAndMoveCamera() async {
//     try {
//       isLoading(true);
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw ('Izin lokasi ditolak.');
//         }
//       }
//       Position position = await Geolocator.getCurrentPosition();
//       mapController?.animateCamera(
//         CameraUpdate.newLatLngZoom(
//           LatLng(position.latitude, position.longitude),
//           15.0,
//         ),
//       );
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   void onMapTapped(LatLng position) {
//     selectedPosition.value = position;
//     markers.clear();
//     markers.add(
//       Marker(
//         markerId: const MarkerId('selected-location'),
//         position: position,
//         infoWindow: const InfoWindow(title: 'Lokasi Dipilih'),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
//       ),
//     );
//     // Kita juga bisa tambahkan logika untuk mengisi TextField alamat dari koordinat (Geocoding)
//   }

//   // Fungsi baru untuk memanggil API pencarian kita sendiri
//   void performSearch(String query) async {
//     isSearching.value = true;
//     try {
//       var results = await LocationSearchService.searchPlaces(query);
//       searchResults.assignAll(results);
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isSearching.value = false;
//     }
//   }

//   // Fungsi untuk menangani saat item hasil pencarian dipilih
//   void onPlaceSelected(String placeId) async {
//     searchResults.clear(); // Sembunyikan daftar hasil
//     Get.focusScope?.unfocus(); // Tutup keyboard

//     try {
//       var details = await LocationSearchService.getPlaceDetails(placeId);
//       final lat = details['geometry']['location']['lat'];
//       final lng = details['geometry']['location']['lng'];
//       final address = details['formatted_address'];

//       searchController.text =
//           address; // Update text field dengan alamat lengkap

//       final latLng = LatLng(lat, lng);
//       mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16.0));
//       onMapTapped(latLng);
//     } catch (e) {
//       Get.snackbar("Error", "Gagal mendapatkan detail lokasi.");
//     }
//   }

//   void confirmLocation() {
//     if (selectedPosition.value != null) {
//       Get.back(
//         result: {
//           'latlng': selectedPosition.value,
//           // Jika searchController kosong, coba ambil alamat dari geocoding nanti
//           'address': searchController.text.isNotEmpty
//               ? searchController.text
//               : 'Lokasi dari Peta',
//         },
//       );
//     } else {
//       Get.snackbar("Peringatan", "Silakan tandai lokasi di peta.");
//     }
//   }

//   void goToPlace(Prediction prediction) {
//     // Ambil lat dan lng dari prediction.lat dan prediction.lng
//     // Gunakan double.tryParse untuk keamanan tipe data
//     final lat = double.tryParse(prediction.lat ?? '0.0');
//     final lng = double.tryParse(prediction.lng ?? '0.0');

//     // Pastikan lat dan lng tidak null setelah parsing
//     if (lat != null && lng != null) {
//       final latLng = LatLng(lat, lng);
//       mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16.0));
//       // Panggil onMapTapped untuk sekaligus menaruh pin di lokasi baru
//       onMapTapped(latLng);
//     }
//   }
// }
