import 'package:flutter/material.dart';
import 'package:ras/models/penginapan.dart';
import 'package:ras/pages/detail_penginapan.dart';
import 'package:ras/pages/discover_page.dart';
import 'package:ras/services/api_service.dart';

class SemuaPenginapanPage extends StatefulWidget {
  const SemuaPenginapanPage({super.key});

  @override
  State<SemuaPenginapanPage> createState() => _SemuaPenginapanPageState();
}

class _SemuaPenginapanPageState extends State<SemuaPenginapanPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Penginapan> _semuaPenginapan = [];
  List<Penginapan> _hasilPencarian = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPenginapan();
    _searchController.addListener(_filterPenginapan);
  }

  Future<void> fetchPenginapan() async {
    try {
      final list = await ApiService().getAllPenginapan();
      setState(() {
        _semuaPenginapan = list;
        _hasilPencarian = list;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching penginapan: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterPenginapan() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _hasilPencarian =
          _semuaPenginapan
              .where((p) => p.nama.toLowerCase().contains(query))
              .toList();
    });
  }

  void _navigateToTab(int index) {
    if (index == 1 || index == 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fitur ini belum tersedia')));
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DiscoverPage(initialIndex: index)),
      (route) => false,
    );
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
            // 🔍 Search Bar
            Container(
              margin: const EdgeInsets.only(bottom: 16, top: 8),
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
            // 🏨 Horizontal List
            _isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : _hasilPencarian.isEmpty
                ? const Expanded(
                  child: Center(child: Text('Penginapan tidak ditemukan')),
                )
                : Expanded(
                  child: ListView.separated(
                    itemCount: _hasilPencarian.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = _hasilPencarian[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => DetailPenginapanPage(penginapan: item),
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
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
                          child: Row(
                            children: [
                              // Gambar
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(12),
                                ),
                                child: Image.network(
                                  item.image,
                                  width: 120,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Informasi
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.rating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
