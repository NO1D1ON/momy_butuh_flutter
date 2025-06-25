import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/job_offer_detail/controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class JobOfferDetailView extends GetView<JobOfferDetailController> {
  const JobOfferDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Penawaran Pekerjaan")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // Data di bawah ini masih statis, nanti akan diganti dari controller.jobOffer.value
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Detail Pemesan
              _buildSectionHeader("Detail Pemesan"),
              _buildInfoCard(
                icon: Icons.person_outline,
                title: "Keluarga Aprilia",
                subtitle: "Medan Johor",
              ),
              const SizedBox(height: 16),

              // Lokasi
              _buildSectionHeader("Lokasi Penjagaan"),
              GestureDetector(
                onTap: () => controller.navigateToClientLocation(),
                child: _buildInfoCard(
                  icon: Icons.location_on_outlined,
                  title: "Jl. Eka Rasmi No. 12A",
                  subtitle: "Ketuk untuk melihat di peta",
                  trailing: const Icon(Icons.map, color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 16),

              // Detail Pekerjaan
              _buildSectionHeader("Detail Pekerjaan"),
              _buildInfoCard(
                icon: Icons.access_time,
                title: "Durasi Penjagaan",
                subtitle: "09:00 - 17:00 (8 jam)",
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                icon: Icons.wallet_outlined,
                title: "Harga Ditawarkan",
                subtitle: "Rp 400.000",
                isPrice: true,
              ),
              const SizedBox(height: 16),

              // Pesan dari Pemesan
              _buildSectionHeader("Catatan dari Pemesan"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Tolong jaga anak saya, usianya 2 tahun. Dia sangat aktif dan suka bermain bola. Makanan dan mainan sudah disiapkan.",
                  style: TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("Ambil Penawaran Ini"),
        ),
      ),
    );
  }

  // Widget helper untuk header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget helper untuk kartu info
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool isPrice = false,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: isPrice
              ? const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                )
              : null,
        ),
        trailing: trailing,
      ),
    );
  }
}
