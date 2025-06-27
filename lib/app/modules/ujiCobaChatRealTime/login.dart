// File: lib/app/modules/login/views/login_view.dart (atau di mana pun halaman login Anda berada)

import 'package:flutter/material.dart';
import 'package:momy_butuh_flutter/app/data/models/user_type.dart'; // Impor enum
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/main_screen.dart'; // Impor service

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  // State untuk melacak tipe pengguna yang dipilih
  UserType _selectedUserType = UserType.parent;

  void _handleLogin() async {
    // Panggil metode login dengan tipe pengguna yang dipilih
    final result = await _authService.login(
      _emailController.text,
      _passwordController.text,
      _selectedUserType,
    );

    if (mounted) {
      if (result['success'] == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // Tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login gagal')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ... (Widget lain seperti logo)

            // --- TAMBAHKAN PEMILIH PERAN ---
            ToggleButtons(
              isSelected: [
                _selectedUserType == UserType.parent,
                _selectedUserType == UserType.babysitter,
              ],
              onPressed: (index) {
                setState(() {
                  _selectedUserType = index == 0
                      ? UserType.parent
                      : UserType.babysitter;
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Orang Tua'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Babysitter'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleLogin, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
