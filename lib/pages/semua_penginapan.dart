import 'package:flutter/material.dart';
import 'detail_penginapan.dart';
import 'discover_page.dart';

class SemuaPenginapanPage extends StatefulWidget {
  const SemuaPenginapanPage({super.key});

  @override
  State<SemuaPenginapanPage> createState() => _SemuaPenginapanPageState();
}

class _SemuaPenginapanPageState extends State<SemuaPenginapanPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _semuaPenginapan = [
    {
      'nama': 'Hotel Bara Beach Bungalows',
      'image': 'assets/images/bara_beach.png',
      'rating': '4,4',
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
      'dekat': 'Benteng Rotterdam, Pantai Losari',
    },
    {
      'nama': 'The Rinra Makassar',
      'image': 'assets/images/rinra.png',
      'rating': '4,6',
      'dekat': 'Pantai Akkarena, Pantai Losari',
    },
    {
      'nama': 'Swiss-Belhotel Makassar',
      'image': 'assets/images/swissbel.png',
      'rating': '4,4',
      'dekat': 'Pulau Samalona, Kodingareng Keke',
    },
    {
      'nama': 'Hotel Grand Town',
      'image': 'assets/images/grand_town.png',
      'rating': '4,1',
      'dekat': 'Taman Nasional Bantimurung',
    },
  ];

  List<Map<String, dynamic>> _hasilPencarian = [];

  @override
  void initState() {
    super.initState();
    _hasilPencarian = _semuaPenginapan;
    _searchController.addListener(_filterPenginapan);
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

  void _filterPenginapan() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _hasilPencarian =
          _semuaPenginapan
              .where(
                (penginapan) =>
                    penginapan['nama'].toLowerCase().contains(query),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Semua Penginapan',
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
                  hintText: 'Cari penginapan',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            // Grid of Filtered Penginapan
            Expanded(
              child:
                  _hasilPencarian.isEmpty
                      ? const Center(child: Text('Penginapan tidak ditemukan'))
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
                                      (context) => DetailPenginapanPage(
                                        nama: item['nama'],
                                        image: item['image'],
                                        rating: item['rating'],
                                        dekat: item['dekat'],
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
