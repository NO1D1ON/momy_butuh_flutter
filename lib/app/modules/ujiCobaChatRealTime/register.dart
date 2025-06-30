// import 'package:flutter/material.dart';
// import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
// import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/login.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _authService = AuthService();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _passwordConfirmController = TextEditingController();

//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _handleRegister() async {
//     if (_nameController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final result = await _authService.register(
//       _nameController.text,
//       _emailController.text,
//       _passwordController.text,
//       _passwordConfirmController.text,
//     );

//     setState(() {
//       _isLoading = false;
//     });

//     if (mounted) {
//       if (result['success'] == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message'] ?? 'Registrasi berhasil')),
//         );
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message'] ?? 'Registrasi gagal')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Registrasi")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Nama Lengkap",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _handleRegister,
//                 child: _isLoading
//                     ? const CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       )
//                     : const Text("Daftar"),
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => const LoginScreen(),
//                     ),
//                   );
//                 },
//                 child: const Text("Sudah punya akun? Masuk di sini"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
