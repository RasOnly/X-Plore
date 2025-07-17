import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ras/widget/buildRestoranCard.dart';
import 'semua_destinasi.dart';
import 'semua_restoran.dart';
import 'semua_penginapan.dart';
import 'detail_wisata.dart';
import 'detail_penginapan.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> sliderImages = [
    'assets/images/slider1.png',
    'assets/images/slider2.png',
    'assets/images/slider3.png',
  ];

  final List<Map<String, dynamic>> _semuaDestinasi = [
    {
      'nama': 'Pantai Tanjung Bira',
      'image': 'assets/images/bira.png',
      'rating': '4,6',
    },
    {
      'nama': 'Taman Purbakala Sumpang Bita',
      'image': 'assets/images/sumpang_bita.png',
      'rating': '4,6',
    },
    {
      'nama': 'Negeri Diatas Awan',
      'image': 'assets/images/negeri_awan.png',
      'rating': '4,6',
    },
    {
      'nama': 'Air Terjun Takapala',
      'image': 'assets/images/takapala.png',
      'rating': '4,5',
    },
    {
      'nama': 'Benteng Rotterdam',
      'image': 'assets/images/rotterdam.png',
      'rating': '4,5',
    },
    {
      'nama': 'Pulau Samalona',
      'image': 'assets/images/samalona.png',
      'rating': '4,7',
    },
    {
      'nama': 'Pantai Akkarena',
      'image': 'assets/images/akkarena.png',
      'rating': '4,5',
    },
    {
      'nama': 'Pantai Losari',
      'image': 'assets/images/losari.png',
      'rating': '4,6',
    },
    {
      'nama': 'Taman Nasional Bantimurung',
      'image': 'assets/images/bantimurung.png',
      'rating': '4,7',
    },
    {
      'nama': 'Pulau Kodingareng Keke',
      'image': 'assets/images/kodingareng_keke.png',
      'rating': '4,8',
    },
    {
      'nama': 'Pantai Tanjung Bayang',
      'image': 'assets/images/tanjung_bayang.png',
      'rating': '4,5',
    },
  ];

  final List<Map<String, dynamic>> _restoranPopuler = [
    {
      'nama': 'd’Perahu Resto',
      'image': 'assets/images/perahu.png',
      'rating': '4,2',
      'dekat': 'Pantai Losari', // Tambahkan informasi lokasi terdekat
    },
    {
      'nama': 'Konro Karebosi',
      'image': 'assets/images/konro_karebosi.png',
      'rating': '4,6',
      'lokasi': 'Dekat Benteng Rotterdam, Hotel Melia Makassar',
    },
    {
      'nama': 'Pallubasa Serigala',
      'image': 'assets/images/pallubasa_serigala.png',
      'rating': '4,7',
      'lokasi': 'Dekat Hotel Aryaduta, Pantai Losari',
    },
  ];

  // ===================== Tambahkan daftar penginapan ini =====================
  final List<Map<String, dynamic>> _penginapanPopuler = [
    {
      'nama': 'Bara Beach Bungalows',
      'image': 'assets/images/penginapan1.png',
      'rating': '4,5',
      'dekat': 'Pantai Tanjung Bira',
    },
    {
      'nama': 'Amatoa Resort',
      'image': 'assets/images/amatoa.png',
      'rating': '4,5',
      'dekat': 'Pantai Tanjung Bira',
    },
    {
      'nama': 'Villa Hutan Pinus Malino',
      'image': 'assets/images/hutan_pinus.png',
      'rating': '4,5',
      'dekat': 'Negeri Diatas Awan, Air Terjun Takapala',
    },
    {
      'nama': 'Hotel Aryaduta Makassar',
      'image': 'assets/images/aryaduta.png',
      'rating': '4,5',
      'dekat': 'Pantai Losari, Benteng Rotterdam',
    },
  ];
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < sliderImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Stack(
        children: [
          // ===================== SLIDER ==========================
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: 204,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  sliderImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),

          // ===================== HEADER ==========================
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Lokasi Anda',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Makassar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 26,
                ),
              ],
            ),
          ),

          // ===================== BODY ==========================
          Positioned(
            top: 285,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _sectionTitle(
                    'Destinasi Wisata Populer',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SemuaDestinasiPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _destinationCard(
                          title: 'Pantai Tanjung Bira',
                          imagePath: 'assets/images/bira.png',
                          rating: '4,6',
                          location: 'Bira, Bulukumba',
                          description:
                              'Pantai Tanjung Bira adalah salah satu destinasi wisata populer di Sulawesi Selatan...',
                          reviewCount: '2.002',
                        ),
                        const SizedBox(width: 16),
                        _destinationCard(
                          title: 'Taman Purbakala Sumpang Bita',
                          imagePath: 'assets/images/sumpang_bita.png',
                          rating: '4,6',
                          location: 'Pangkep, Sulawesi Selatan',
                          description:
                              'Taman Purbakala Sumpang Bita adalah situs purbakala yang memiliki nilai sejarah tinggi...',
                          reviewCount: '1.200',
                        ),
                        const SizedBox(width: 16),
                        _destinationCard(
                          title: 'Benteng Rotterdam',
                          imagePath: 'assets/images/rotterdam.png',
                          rating: '4,5',
                          location: 'Makassar',
                          description:
                              'Benteng Rotterdam adalah benteng peninggalan Belanda yang bersejarah di Makassar.',
                          reviewCount: '1.500',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(
                    'Restoran Populer',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SemuaRestoranPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Column(
                    // Wrap with Column to make it scrollable vertically within ListView
                    children:
                        _restoranPopuler.map((restoran) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ), // Padding antar kartu
                            child: _penginapanCard(
                              // Menggunakan fungsi _penginapanCard yang baru
                              title: restoran['nama'],
                              imagePath: restoran['image'],
                              rating: restoran['rating'],
                              dekat:
                                  restoran['lokasi'] ??
                                  '', // Teruskan data 'dekat'
                            ),
                          );
                        }).toList(),
                  ),

                  // _restoranPopuler.map((restoran) {
                  //   return Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 8,
                  //     ),
                  //   );
                  // }).toList(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  _sectionTitle(
                    'Penginapan Populer',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SemuaPenginapanPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // ===================== Gunakan ListView.builder untuk penginapan =====================
                  Column(
                    // Wrap with Column to make it scrollable vertically within ListView
                    children:
                        _penginapanPopuler.map((penginapan) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ), // Padding antar kartu
                            child: _penginapanCard(
                              // Menggunakan fungsi _penginapanCard yang baru
                              title: penginapan['nama'],
                              imagePath: penginapan['image'],
                              rating: penginapan['rating'],
                              dekat:
                                  penginapan['dekat'], // Teruskan data 'dekat'
                            ),
                          );
                        }).toList(),
                  ),
                  // ========================================================================================
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // ===================== SEARCH BAR ==========================
          Positioned(
            top: 260,
            left: MediaQuery.of(context).size.width / 2 - 172, // 344 / 2
            child: Container(
              height: 42,
              width: 344,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari destinasi',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'Lihat Semua',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _destinationCard({
    required String title,
    required String imagePath,
    required String rating,
    required String location,
    required String description,
    required String reviewCount,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => DetailWisataPage(
                  nama: title,
                  image: imagePath,
                  rating: rating,
                  semuaDestinasi: _semuaDestinasi,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                height: 90,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== Fungsi baru untuk Penginapan Card =====================
  Widget _penginapanCard({
    required String title,
    required String imagePath,
    required String rating,
    required String dekat, // Tambahkan parameter ini
  }) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke DetailPenginapanPage saat kartu diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetailPenginapanPage(
                  nama: title,
                  image: imagePath,
                  rating: rating,
                  dekat: dekat, // Teruskan parameter 'dekat'
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
