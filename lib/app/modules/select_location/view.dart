import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:momy_butuh_flutter/app/modules/select_location/controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class SelectLocationView extends GetView<SelectLocationController> {
  const SelectLocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              initialCameraPosition: controller.initialCameraPosition,
              onMapCreated: (mapCtrl) => controller.mapController = mapCtrl,
              onTap: controller.onMapTapped,
              markers: controller.markers.value,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),

          // Kolom Pencarian
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller.searchController,
                googleAPIKey:
                    "AIzaSyDX0NUe4AbmA10BGiWVpyD28AYeW0Z7TTk", // <-- GANTI DENGAN API KEY ANDA
                inputDecoration: InputDecoration(
                  hintText: "Cari nama jalan atau tempat...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.primaryColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => controller.searchController.clear(),
                  ),
                ),
                debounceTime: 400,
                countries: const ["id"],

                // --- PERBAIKAN UTAMA DI SINI ---
                // Kita hanya gunakan itemClick sekarang
                itemClick: (Prediction prediction) {
                  // Isi TextField dengan nama lokasi yang dipilih
                  controller.searchController.text =
                      prediction.description ?? "";
                  controller
                      .searchController
                      .selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description?.length ?? 0),
                  );
                  // Panggil controller untuk menggerakkan peta ke lokasi yang dipilih
                  controller.goToPlace(prediction);
                },
                // getPlaceDetailWithLatLng tidak lagi kita perlukan
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 5,
            child: SafeArea(
              child: BackButton(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Obx(
              () => ElevatedButton.icon(
                onPressed: controller.selectedPosition.value != null
                    ? () => controller.confirmLocation()
                    : null,
                icon: const Icon(Icons.check),
                label: const Text("Pilih Lokasi Ini"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:momy_butuh_flutter/app/modules/select_location/controller.dart';
// import 'package:momy_butuh_flutter/app/utils/theme.dart';

// class SelectLocationView extends GetView<SelectLocationController> {
//   const SelectLocationView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // --- PERBAIKAN UTAMA DI SINI ---
//           // GoogleMap tidak lagi dibungkus dengan Obx secara keseluruhan
//           GoogleMap(
//             initialCameraPosition: controller.initialCameraPosition,
//             onMapCreated: (mapCtrl) {
//               controller.mapController = mapCtrl;
//               controller.determinePositionAndMoveCamera();
//             },
//             onTap: controller.onMapTapped,
//             // HANYA properti 'markers' yang dibungkus dengan Obx
//             markers: controller.markers.value,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//           ),

//           // Kolom Pencarian (tidak perlu di dalam Obx)
//           Positioned(
//             top: 50,
//             left: 15,
//             right: 15,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: GooglePlaceAutoCompleteTextField(
//                 textEditingController: controller.searchController,
//                 googleAPIKey:
//                     "AIzaSyDX0NUe4AbmA10BGiWVpyD28AYeW0Z7TTk", // <-- GANTI DENGAN API KEY ANDA
//                 inputDecoration: InputDecoration(
//                   hintText: "Cari nama jalan atau tempat...",
//                   prefixIcon: const Icon(
//                     Icons.search,
//                     color: AppTheme.primaryColor,
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.clear, color: Colors.grey),
//                     onPressed: () => controller.searchController.clear(),
//                   ),
//                 ),
//                 debounceTime: 400,
//                 countries: const ["id"],
//                 itemClick: (Prediction prediction) {
//                   controller.searchController.text =
//                       prediction.description ?? "";
//                   controller
//                       .searchController
//                       .selection = TextSelection.fromPosition(
//                     TextPosition(offset: prediction.description?.length ?? 0),
//                   );
//                   controller.goToPlace(prediction);
//                 },
//               ),
//             ),
//           ),

//           Positioned(
//             top: 10,
//             left: 5,
//             child: SafeArea(
//               child: BackButton(color: Colors.black.withOpacity(0.6)),
//             ),
//           ),

//           // Tombol Konfirmasi (hanya bagian ini yang perlu Obx)
//           Positioned(
//             bottom: 24,
//             left: 24,
//             right: 24,
//             child: Obx(
//               () => ElevatedButton.icon(
//                 onPressed: controller.selectedPosition.value != null
//                     ? () => controller.confirmLocation()
//                     : null,
//                 icon: const Icon(Icons.check),
//                 label: const Text("Pilih Lokasi Ini"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
