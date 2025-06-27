import 'package:flutter/material.dart';
import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/conversation_list.dart';
// Impor halaman lain yang Anda miliki, contoh:
// import 'home_screen.dart';
// import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Indeks halaman yang aktif

  // Daftar halaman yang akan ditampilkan di BottomNavBar
  static const List<Widget> _widgetOptions = <Widget>[
    // Ganti Text('Home') dengan widget halaman utama Anda
    Center(child: Text('Halaman Utama')),
    // Ini adalah halaman daftar percakapan kita
    ConversationListScreen(),
    // Ganti Text('Profile') dengan widget halaman profil Anda
    Center(child: Text('Halaman Profil')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
