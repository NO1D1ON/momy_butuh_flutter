import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_search/controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class BabysitterSearchView extends GetView<BabysitterSearchController> {
  const BabysitterSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Kolom pencarian tunggal yang lebih bersih
        title: TextField(
          controller: controller.searchC,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari nama atau lokasi babysitter...',
            border: InputBorder.none,
          ),
          onChanged: controller.onSearchChanged,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        if (controller.searchResults.isEmpty &&
            controller.searchC.text.isNotEmpty) {
          return const Center(child: Text('Babysitter tidak ditemukan.'));
        }
        if (controller.searchResults.isEmpty) {
          return const Center(child: Text('Mulai ketik untuk mencari.'));
        }
        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final babysitter = controller.searchResults[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(babysitter.name),
              subtitle: Text(babysitter.address),
              onTap: () => Get.toNamed(
                Routes.BABYSITTER_DETAIL,
                arguments: babysitter.id,
              ),
            );
          },
        );
      }),
    );
  }
}
