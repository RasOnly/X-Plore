import 'package:flutter/material.dart';
import 'detail_restoran.dart';
import 'discover_page.dart';

final List<Map<String, dynamic>> semuaRestoranData = [
  {
    'nama': 'RM Seafood Apong',
    'image': 'assets/images/seafood_apong.png',
    'rating': '4.6',
    'lokasi': 'Dekat Pantai Losari, Hotel Aryaduta Makassar',
  },
  {
    'nama': 'Coto Nusantara',
    'image': 'assets/images/coto_nusantara.png',
    'rating': '4.5',
    'lokasi': 'Dekat Benteng Rotterdam, Pantai Losari',
  },
  {
    'nama': 'Pallubasa Serigala',
    'image': 'assets/images/pallubasa_serigala.png',
    'rating': '4.7',
    'lokasi': 'Dekat Hotel Aryaduta, Pantai Losari',
  },
  {
    'nama': 'Konro Karebosi',
    'image': 'assets/images/konro_karebosi.png',
    'rating': '4.6',
    'lokasi': 'Dekat Kantor Gubernur, Pusat Kota',
  },
];

class SemuaRestoranPage extends StatefulWidget {
  const SemuaRestoranPage({super.key});

  @override
  State<SemuaRestoranPage> createState() => _SemuaRestoranPageState();
}

class _SemuaRestoranPageState extends State<SemuaRestoranPage> {
  final TextEditingController _searchController = TextEditingController();

  // Filtered list based on search query
  List<Map<String, dynamic>> _filteredRestoran = [];

  @override
  void initState() {
    super.initState();
    _filteredRestoran = semuaRestoranData; // Initialize with full list
    _searchController.addListener(_filterRestoran);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToTab(int index) {
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur scan QR belum tersedia')),
      );
      return;
    }
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur peta belum tersedia')),
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DiscoverPage(initialIndex: index)),
      (route) => false,
    );
  }

  void _filterRestoran() {
    setState(() {
      _filteredRestoran =
          semuaRestoranData.where((restoran) {
            final nameLower = (restoran['nama'] as String).toLowerCase();
            final searchLower = _searchController.text.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restoran',
          style: TextStyle(
            color: Colors.blue, // Warna biru
            fontFamily: 'Poppins', // Gunakan font Poppins
            fontWeight: FontWeight.bold, // Bold sedang (600 = semi-bold)
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Mengatur warna AppBar menjadi putih
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 239, 239, 239),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _filteredRestoran.isEmpty
                      ? Center(
                        child: Text(
                          'Tidak ada restoran ditemukan.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                      : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 408 / 333,
                            ),
                        itemCount: _filteredRestoran.length,
                        itemBuilder: (context, index) {
                          final item = _filteredRestoran[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailRestoranPage(
                                        nama: item['nama'],
                                        image: item['image'],
                                        rating: item['rating'],
                                        dekat: item['lokasi'],
                                        semuaRestoran: semuaRestoranData,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              width: 408, // Sesuai spesifikasi
                              height: 333, // 253 (gambar) + 80 (info)
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // Border radius keseluruhan
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8), // Top radius 8px
                                    ),
                                    child: Image.asset(
                                      item['image'],
                                      width: 408, // Sesuai spesifikasi
                                      height: 253, // Sesuai spesifikasi
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    width: 408, // Sesuai spesifikasi
                                    height: 80, // Sesuai spesifikasi
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(
                                          8,
                                        ), // Bottom radius 8px
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 19,
                                      vertical: 14,
                                    ), // Padding disesuaikan agar teks berada pada posisi yang diminta
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['nama'],
                                                style: const TextStyle(
                                                  fontSize:
                                                      18, // Ukuran font disesuaikan
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins',
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .location_on, // Icon lokasi
                                                    color:
                                                        Colors
                                                            .grey, // Warna abu-abu
                                                    size:
                                                        16, // Ukuran disesuaikan
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      item['lokasi'],
                                                      style: const TextStyle(
                                                        fontSize:
                                                            13, // Ukuran font disesuaikan
                                                        color:
                                                            Colors
                                                                .grey, // Warna abu-abu
                                                        fontFamily: 'Poppins',
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item['rating'] as String? ??
                                                  '0.0',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DiscoverNavBar(
        currentIndex: 0,
        onTabTapped: _navigateToTab,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur scan QR belum tersedia')),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
