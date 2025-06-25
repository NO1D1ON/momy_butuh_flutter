import 'package:flutter/material.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class BabysitterBookingsView extends StatelessWidget {
  const BabysitterBookingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesanan Saya")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Akan Datang",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Card untuk booking yang akan datang (warna tema)
          Card(
            color: AppTheme.primaryColor.withOpacity(0.15),
            child: const ListTile(
              leading: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
              title: Text("Booking dari Rita Sari"),
              subtitle: Text("27 Juni 2025 - 09:00-12:00"),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Selesai",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Card untuk booking yang sudah selesai (warna hijau)
          Card(
            color: Colors.green.withOpacity(0.15),
            child: const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("Booking dari Budi"),
              subtitle: Text("20 Juni 2025 - 13:00-17:00"),
            ),
          ),
        ],
      ),
    );
  }
}
