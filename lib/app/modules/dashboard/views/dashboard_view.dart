import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../utils/theme.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman sesuai tab yang aktif.
      // IndexedStack menjaga state setiap halaman agar tidak hilang saat berpindah tab.
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: controller.pages,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Obx(
        () => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex.value,
            selectedItemColor: Color(0xFFFFDA76),
            unselectedItemColor: Colors.white,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.primaryColor,
            elevation: 5,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.map_outlined),
              //   label: 'Peta',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Booking',
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
