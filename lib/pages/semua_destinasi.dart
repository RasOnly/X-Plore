import 'package:flutter/material.dart';
import 'discover_page.dart';
import 'detail_wisata.dart';

class SemuaDestinasiPage extends StatefulWidget {
  const SemuaDestinasiPage({super.key});

  @override
  State<SemuaDestinasiPage> createState() => _SemuaDestinasiPageState();
}

class _SemuaDestinasiPageState extends State<SemuaDestinasiPage> {
  final TextEditingController _searchController = TextEditingController();

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

  List<Map<String, dynamic>> _hasilPencarian = [];

  @override
  void initState() {
    super.initState();
    _hasilPencarian = _semuaDestinasi;
    _searchController.addListener(_filterDestinasi);
  }

  void _filterDestinasi() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _hasilPencarian =
          _semuaDestinasi
              .where(
                (destinasi) => destinasi['nama'].toLowerCase().contains(query),
              )
              .toList();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Destinasi Wisata',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari destinasi',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            // Grid of Filtered Destinations
            Expanded(
              child:
                  _hasilPencarian.isEmpty
                      ? const Center(child: Text('Destinasi tidak ditemukan'))
                      : GridView.builder(
                        itemCount: _hasilPencarian.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 3 / 2.5,
                            ),
                        itemBuilder: (context, index) {
                          final item = _hasilPencarian[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailWisataPage(
                                        nama: item['nama'],
                                        image: item['image'],
                                        rating: item['rating'],
                                        // Meneruskan seluruh daftar destinasi
                                        semuaDestinasi: _semuaDestinasi,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
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
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      item['image'],
                                      height: 90,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item['nama'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item['rating'],
                                          style: const TextStyle(fontSize: 12),
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
