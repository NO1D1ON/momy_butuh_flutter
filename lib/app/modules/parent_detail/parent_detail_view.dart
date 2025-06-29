import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/modules/parent_detail/parent_detail_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class ParentDetailView extends GetView<ParentDetailController> {
  const ParentDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          "Detail Pesanan & Pemesan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal, // Tidak terlalu tebal
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        // PENGECEKAN DIPERBAIKI: Cek parentProfile dan juga booking
        if (controller.parentProfile.value == null ||
            controller.booking == null) {
          return const Center(child: Text("Gagal memuat detail data."));
        }

        final parent = controller.parentProfile.value!;
        // Booking sekarang diambil langsung dari controller dan dijamin tidak null
        final booking = controller.booking;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Detail Pemesan ---
              Text(
                "Informasi Pemesan",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                children: [
                  _buildInfoRow(
                    Icons.person_outline,
                    "Nama",
                    parent.name ?? 'Tidak ada nama',
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Nomor Telepon",
                    parent.phoneNumber ?? 'Tidak tersedia',
                  ),
                  GestureDetector(
                    onTap: () =>
                        controller.openMap(parent.latitude, parent.longitude),
                    child: _buildInfoRow(
                      Icons.location_on_outlined,
                      "Alamat",
                      parent.address ?? 'Tidak tersedia',
                      isLast: true,
                      trailing: const Icon(
                        Icons.map_outlined,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Detail Pekerjaan ---
              Text(
                "Jadwal Kerja",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                children: [
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    "Tanggal",
                    // Pastikan jobDate tidak null sebelum di-format
                    booking.jobDate != null
                        ? DateFormat(
                            'EEEE, d MMMM y',
                            'id_ID',
                          ).format(booking.jobDate!)
                        : 'Tanggal tidak diatur',
                  ),
                  // Asumsi startTime dan endTime ada di model Booking
                  _buildInfoRow(
                    Icons.access_time_outlined,
                    "Waktu",
                    // Ganti dengan data dinamis jika sudah ada di model
                    "${booking.startTime ?? 'N/A'} - ${booking.endTime ?? 'N/A'}",
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  // Widget helper untuk membuat kartu informasi
  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // Widget helper untuk menampilkan baris informasi
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          if (!isLast) const Divider(height: 1, indent: 54),
        ],
      ),
    );
  }
}
