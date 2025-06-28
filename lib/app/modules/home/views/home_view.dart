import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../utils/theme.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Beri warna latar yang lembut
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Get.toNamed(Routes.CREATE_JOB_OFFER),
      //   label: const Text("Buat Penawaran"),
      //   icon: const Icon(Icons.add),
      //   backgroundColor: AppTheme.primaryColor,
      // ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.fetchBabysitters(),
          color: AppTheme.primaryColor,
          child: CustomScrollView(
            // Ganti ListView dengan CustomScrollView
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  // --- WIDGET BAGIAN ATAS (Header Besar Biru) ---
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 150,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor, // Warna biru sesuai gambar
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20), // Rounded bawah kiri
                        bottomRight: Radius.circular(20), // Rounded bawah kanan
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10), // Spasi dari atas SafeArea
                        // Nama Aplikasi / Header
                        Obx(
                          () => Text(
                            "Halo, ${controller.parentName.value}!",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Text(
                          "Temukan pengasuh terbaik\nuntuk buah hati Anda.",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // --- WIDGET KECIL (Putih dengan 3 Bagian) ---
                  Transform.translate(
                    offset: const Offset(
                      0.0,
                      -40.0,
                    ), // Geser ke atas agar tumpang tindih dengan header biru
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15,
                          ), // Sudut membulat
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Widget Map
                              _buildSmallFeatureItem(
                                icon: Icons.location_on_outlined,
                                label: "Babysitter Terdekat",
                                onTap: () {
                                  // Navigasi ke halaman Peta
                                  Get.toNamed(
                                    Routes.MAP_VIEW,
                                  ); // Sesuaikan rute Anda
                                },
                              ),
                              // Widget Favorit
                              _buildSmallFeatureItem(
                                icon: Icons.favorite_border,
                                label: "Favorit",
                                onTap: () {
                                  // Navigasi ke halaman Favorit
                                  Get.toNamed(
                                    Routes.BABYSITTER_FAVORITE,
                                  ); // Sesuaikan rute Anda
                                },
                              ),
                              // Widget Top Up (asumsi ini adalah "isi saldo" atau semacamnya)
                              _buildSmallFeatureItem(
                                icon: Icons
                                    .add_to_photos_outlined, // Icon dompet atau top up
                                label: "Tambah Tawaran",
                                onTap: () {
                                  Get.toNamed(Routes.CREATE_JOB_OFFER);
                                  // Get.snackbar(
                                  //   'Fitur',
                                  //   'Fitur Top Up belum diimplementasikan.',
                                  // );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- WIDGET PENCARIAN (Tetap ada di bawah widget kecil) ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      readOnly: true,
                      onTap: () => Get.toNamed(Routes.BABYSITTER_SEARCH),
                      decoration: InputDecoration(
                        hintText: 'Cari Babysitter...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,

                        // Border default saat tidak fokus
                        enabledBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme
                                .primaryColor, // Warna border saat normal
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- JUDUL DAFTAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Text(
                      "Rekomendasi Babysitter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ]),
              ),

              // --- DAFTAR BABYSITTER DINAMIS (DIUBAH KE LIST VIEW) ---
              // Menggunakan SliverToBoxAdapter untuk menyematkan Column dalam CustomScrollView
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    );
                  }
                  if (controller.babysitterList.isEmpty) {
                    return const Center(
                      child: Text("Belum ada babysitter yang tersedia."),
                    );
                  }
                  return Column(
                    children: List.generate(controller.babysitterList.length, (
                      index,
                    ) {
                      final babysitter = controller.babysitterList[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                          left: 20,
                          right: 20,
                        ), // Spasi antar item
                        child: InkWell(
                          onTap: () => Get.toNamed(
                            Routes.BABYSITTER_DETAIL,
                            arguments: babysitter.id,
                          ),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                12.0,
                              ), // Padding di dalam card
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Gambar/Avatar Babysitter
                                  Container(
                                    width: 80, // Ukuran lebar gambar
                                    height: 80, // Ukuran tinggi gambar
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ), // Sudut membulat pada gambar
                                      color: AppTheme.primaryColor.withOpacity(
                                        0.1,
                                      ), // Warna placeholder
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          babysitter.photoUrl ??
                                              'https://placehold.co/80x80/E0E0E0/white?text=User',
                                        ), // Ganti dengan URL gambar profil asli jika ada
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {
                                          // Placeholder jika gambar gagal dimuat
                                          return; // Lakukan sesuatu jika ada error loading gambar
                                        },
                                      ),
                                    ),
                                    child:
                                        babysitter.photoUrl == null ||
                                            babysitter.photoUrl!.isEmpty
                                        ? const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: AppTheme.primaryColor,
                                          )
                                        : null, // Jika ada gambar, jangan tampilkan ikon
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ), // Spasi antara gambar dan detail
                                  // Detail Babysitter
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          babysitter.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          // Asumsi ada properti 'location' atau 'experience'
                                          "${babysitter.age} Tahun, ${babysitter.address ?? 'Lokasi Tidak Diketahui'}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        // Baris untuk Rating
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                Text(
                                                  // Asumsi ada properti rating di model
                                                  " ${babysitter.rating?.toStringAsFixed(1) ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // --- PERBAIKAN DIMULAI DI SINI ---
                                            // Gunakan Obx untuk membuat ikon reaktif
                                            Obx(() {
                                              // Cek apakah ID babysitter ada di dalam list favorit
                                              final isFavorite = controller
                                                  .favoriteIds
                                                  .contains(babysitter.id);
                                              return IconButton(
                                                // Atur padding dan constraints agar pas
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                icon: Icon(
                                                  // Tampilkan ikon berbeda berdasarkan status favorit
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  // Ubah warna berdasarkan status favorit
                                                  color: isFavorite
                                                      ? AppTheme.primaryColor
                                                      : Colors.grey.shade400,
                                                  size: 22,
                                                ),
                                                // Panggil fungsi toggle dari controller saat ditekan
                                                onPressed: () =>
                                                    controller.toggleFavorite(
                                                      babysitter.id,
                                                    ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk widget kecil dengan icon dan label
  Widget _buildSmallFeatureItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(
                0.1,
              ), // Background lingkaran icon
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
