import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_search/controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';

class BabysitterSearchView extends GetView<BabysitterSearchController> {
  const BabysitterSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Kolom pencarian langsung di AppBar
        title: TextField(
          controller: controller.searchController,
          autofocus: true, // Langsung fokus saat halaman dibuka
          decoration: const InputDecoration(
            hintText: 'Ketik nama babysitter...',
            border: InputBorder.none,
          ),
          onChanged: controller.onSearchChanged,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.searchResults.isEmpty &&
            controller.searchController.text.isNotEmpty) {
          return const Center(child: Text('Babysitter tidak ditemukan.'));
        }
        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final babysitter = controller.searchResults[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(babysitter.name),
              subtitle: Text("${babysitter.age} Tahun - ${babysitter.address}"),
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
