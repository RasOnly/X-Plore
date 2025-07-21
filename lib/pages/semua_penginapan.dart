import 'package:flutter/material.dart';
import 'package:ras/services/api_service.dart';
import 'package:ras/models/penginapan.dart';
import 'detail_penginapan.dart';
import 'discover_page.dart';

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
      final penginapanList = await ApiService().getAllPenginapan();
      setState(() {
        _semuaPenginapan = penginapanList;
        _hasilPencarian = penginapanList;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat penginapan: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterPenginapan() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _hasilPencarian =
          _semuaPenginapan
              .where(
                (penginapan) => penginapan.nama.toLowerCase().contains(query),
              )
              .toList();
    });
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
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
                    // Grid Penginapan
                    Expanded(
                      child:
                          _hasilPencarian.isEmpty
                              ? const Center(
                                child: Text('Penginapan tidak ditemukan'),
                              )
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
                                                penginapan: item,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                            child: Image.network(
                                              item.image,
                                              height: 90,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              item.nama,
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
                                                  item.rating.toStringAsFixed(
                                                    1,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
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
