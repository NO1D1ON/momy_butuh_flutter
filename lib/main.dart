import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "MomyButuh",
      initialRoute: AppPages.INITIAL, // Halaman awal adalah Splash Screen
      getPages: AppPages.routes, // Ambil semua daftar halaman
      theme: AppTheme.lightTheme, // Terapkan tema yang sudah kita buat
      debugShowCheckedModeBanner: false,
    );
  }
}
