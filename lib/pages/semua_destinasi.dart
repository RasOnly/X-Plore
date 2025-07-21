import 'package:flutter/material.dart';
import 'package:ras/models/wisata.dart';
import 'package:ras/pages/detail_wisata.dart';
import 'package:ras/pages/discover_page.dart';
import 'package:ras/services/api_service.dart';

class SemuaDestinasiPage extends StatefulWidget {
  const SemuaDestinasiPage({super.key});

  @override
  State<SemuaDestinasiPage> createState() => _SemuaDestinasiPageState();
}

class _SemuaDestinasiPageState extends State<SemuaDestinasiPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Wisata> _semuaDestinasi = [];
  List<Wisata> _hasilPencarian = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDestinasi();
    _searchController.addListener(_filterDestinasi);
  }

  Future<void> _fetchDestinasi() async {
    try {
      final wisataList = await ApiService().getAllWisata();
      setState(() {
        _semuaDestinasi = wisataList;
        _hasilPencarian = wisataList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error fetching wisata: $e');
    }
  }

  void _filterDestinasi() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _hasilPencarian =
          _semuaDestinasi
              .where((wisata) => wisata.nama.toLowerCase().contains(query))
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
          'Destinasi Wisata',
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
                  children: [_buildSearchBar(), _buildGridWisata()],
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

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
    );
  }

  Widget _buildGridWisata() {
    if (_hasilPencarian.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Destinasi tidak ditemukan')),
      );
    }

    return Expanded(
      child: GridView.builder(
        itemCount: _hasilPencarian.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      (_) => DetailWisataPage(
                        wisata: item,
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
                    child: Image.network(
                      item.image,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toString(),
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
    );
  }
}
