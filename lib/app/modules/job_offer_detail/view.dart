import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';
import 'controller.dart';

class JobOfferDetailView extends GetView<JobOfferDetailController> {
  const JobOfferDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penawaran'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        if (controller.jobOffer.value == null) {
          return const Center(child: Text('Gagal memuat detail penawaran.'));
        }

        final offer = controller.jobOffer.value!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParentInfo(offer),
              const Divider(height: 24, thickness: 1),
              _buildJobDetails(offer),
            ],
          ),
        );
      }),
      // Tombol aksi di bagian bawah
      bottomNavigationBar: _buildBottomActionButtons(),
    );
  }

  Widget _buildParentInfo(dynamic offer) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
            child: Text(
              offer.parentName.isNotEmpty
                  ? offer.parentName.substring(0, 1).toUpperCase()
                  : 'P',
              style: const TextStyle(
                fontSize: 24,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Keluarga ${offer.parentName}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pembuat Penawaran",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetails(dynamic offer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.location_on_outlined,
            "Lokasi",
            offer.locationAddress,
          ),
          _buildDetailRow(
            Icons.calendar_today_outlined,
            "Tanggal",
            offer.jobDate,
          ),
          _buildDetailRow(
            Icons.access_time_outlined,
            "Waktu",
            "${offer.startTime} - ${offer.endTime}",
          ),
          _buildDetailRow(
            Icons.wallet_giftcard,
            "Upah Ditawarkan",
            "Rp ${offer.offeredPrice}",
          ),
          const SizedBox(height: 16),
          const Text(
            "Deskripsi Pekerjaan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            offer.description,
            style: TextStyle(color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Obx(
        () => controller.isAccepting.value
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
            : ElevatedButton(
                onPressed: controller.acceptOffer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Terima Tawaran",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
