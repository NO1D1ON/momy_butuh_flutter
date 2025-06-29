import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_dashboard/babysitter_dashboard_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class BabysitterDashboardView extends GetView<BabysitterDashboardController> {
  const BabysitterDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body sekarang menggunakan IndexedStack untuk menjaga state halaman
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: controller.pages,
        ),
      ),

      // Menggunakan BottomNavigationBar dengan gaya dari login orang tua
      bottomNavigationBar: Obx(
        () => ClipRRect(
          // 1. Bungkus dengan ClipRRect untuk sudut melengkung
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex.value,
            // 2. Terapkan skema warna yang sama
            backgroundColor: AppTheme.primaryColor,
            selectedItemColor: const Color(
              0xFFFFDA76,
            ), // Warna highlight seperti parent
            unselectedItemColor: Colors.white, // Warna non-aktif
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 5, // Tambahkan elevasi
            items: const [
              // 3. Ikon dan label tetap sesuai dengan babysitter
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Pesanan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'Pesan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
