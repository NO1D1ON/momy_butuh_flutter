import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsService {
  // Ganti dengan API Key Anda yang sesungguhnya
  static const String googleApiKey = "AIzaSyDX0NUe4AbmA10BGiWVpyD28AYeW0Z7TTk";

  // Fungsi untuk mendapatkan titik-titik rute antara dua lokasi
  static Future<List<LatLng>> getDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    PolylinePoints polylinePoints = PolylinePoints();

    // --- PERBAIKAN DI SINI ---
    // 1. Buat sebuah objek PolylineRequest
    final PolylineRequest request = PolylineRequest(
      origin: PointLatLng(origin.latitude, origin.longitude),
      destination: PointLatLng(destination.latitude, destination.longitude),
      mode: TravelMode.driving, // Anda bisa ganti mode perjalanan
    );

    // 2. Panggil fungsi dengan menggunakan parameter 'request'
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: request,
    );
    // --- BATAS PERBAIKAN ---

    if (result.points.isNotEmpty) {
      // Jika rute ditemukan, ubah menjadi list LatLng
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }

    // Jika tidak ada rute, kembalikan list kosong
    return [];
  }
}
