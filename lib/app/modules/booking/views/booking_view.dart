import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking ${controller.babysitter.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Detail Pemesanan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            _buildInfoRow("Babysitter", controller.babysitter.name),
            const Divider(),
            _buildPickerRow(
              context: context,
              icon: Icons.calendar_today,
              label: "Tanggal Penggunaan Jasa",
              onTap: () => controller.pickDate(context),
              value: Obx(
                () => Text(
                  controller.selectedDate.value == null
                      ? "Pilih Tanggal"
                      : DateFormat(
                          'd MMMM yyyy',
                        ).format(controller.selectedDate.value!),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            _buildPickerRow(
              context: context,
              icon: Icons.access_time,
              label: "Jam Mulai",
              onTap: () => controller.pickTime(context, isStartTime: true),
              value: Obx(
                () => Text(
                  controller.startTime.value == null
                      ? "Pilih Jam"
                      : controller.startTime.value!.format(context),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            _buildPickerRow(
              context: context,
              icon: Icons.timer_off_outlined,
              label: "Jam Selesai",
              onTap: () => controller.pickTime(context, isStartTime: false),
              value: Obx(
                () => Text(
                  controller.endTime.value == null
                      ? "Pilih Jam"
                      : controller.endTime.value!.format(context),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => _buildInfoRow(
                "Total Bayar",
                "Rp ${NumberFormat('#,##0', 'id_ID').format(controller.totalPrice.value)}",
                isTotal: true,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.confirmBooking(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text("Konfirmasi & Bayar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 20 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Widget value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(label),
      trailing: value,
      onTap: onTap,
    );
  }
}
