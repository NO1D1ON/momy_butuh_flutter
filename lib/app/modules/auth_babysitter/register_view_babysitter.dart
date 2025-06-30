import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/modules/auth_babysitter/auth_babysitter_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class RegisterBabysitterView extends GetView<AuthBabysitterController> {
  const RegisterBabysitterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- PERBAIKAN DI SINI ---
        // Menambahkan tombol kembali secara eksplisit
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Get.back(), // Fungsi untuk kembali ke halaman sebelumnya
        ),

        // --- BATAS PERBAIKAN ---
        title: const Text(
          'Daftar Akun Babysitter',
          style: TextStyle(
            color: Colors.white,
          ), // Tambahkan warna teks agar kontras
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true, // Agar judul berada di tengah
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Buat Akun Babysitter Anda',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller.registerNameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.registerEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.registerPhoneController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.registerBirthDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Lahir',
                hintText: 'YYYY-MM-DD',
              ),
              onTap: () async {
                // Tampilkan date picker saat field ditekan
                FocusScope.of(
                  context,
                ).requestFocus(FocusNode()); // tutup keyboard
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  controller.registerBirthDateController.text = DateFormat(
                    'yyyy-MM-dd',
                  ).format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.registerAddressController,
              decoration: const InputDecoration(labelText: 'Alamat Lengkap'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.registerPasswordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.registerPasswordConfirmController,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.register(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Daftar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
