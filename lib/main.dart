import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/theme.dart';

// 1. Jadikan fungsi main menjadi async
void main() async {
  // 2. Tambahkan dua baris ini untuk memastikan inisialisasi berjalan
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // 3. Panggil runApp dengan widget utama Anda
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Baris inisialisasi sudah dipindahkan ke fungsi main()

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "MomyButuh",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('id', 'ID'),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MomyButuh',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       // Atur SplashScreen sebagai halaman pertama
//       home: const SplashScreen(),
//     );
//   }
// }
