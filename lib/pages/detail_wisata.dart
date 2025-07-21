import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ras/models/wisata.dart';
import 'package:ras/pages/review_list_page.dart';
import 'package:ras/pages/discover_page.dart';
import 'package:ras/pages/semua_penginapan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailWisataPage extends StatefulWidget {
  final Wisata wisata;
  final List<Wisata> semuaDestinasi;

  const DetailWisataPage({
    super.key,
    required this.wisata,
    required this.semuaDestinasi,
  });

  @override
  State<DetailWisataPage> createState() => _DetailWisataPageState();
}

class _DetailWisataPageState extends State<DetailWisataPage> {
  late List<Wisata> destinasiLainnya;
  late List<String> images;
  final PageController _pageController = PageController();
  int _currentImage = 0;
  bool isFavorit = false;

  @override
  void initState() {
    super.initState();
    print('📌 ID Wisata: ${widget.wisata.id}');
    images = _getImages(widget.wisata.image);
    destinasiLainnya =
        widget.semuaDestinasi
            .where((item) => item.id != widget.wisata.id)
            .take(5)
            .toList();
    _loadFavorit();
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

  Future<void> _toggleFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null || userId <= 0) {
      print('[ERROR] user_id tidak ditemukan di SharedPreferences');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan favorit. User belum login.'),
        ),
      );
      return;
    }

    final key = 'favorite_${widget.wisata.id}';
    final newStatus = !isFavorit;

    setState(() {
      isFavorit = newStatus;
    });

    prefs.setBool(key, newStatus);
    print('🔄 Toggle favorit: user_id=$userId, wisata_id=${widget.wisata.id}');

    if (newStatus) {
      await _sendFavoriteToBackend(userId);
    } else {
      await _removeFavoriteFromBackend(userId);
    }
  }

  Future<void> _sendFavoriteToBackend(int userId) async {
    final url = Uri.parse(
      'https://xplore-app-328588022038.asia-southeast2.run.app/api/user/wisata/favorites',
    );
    final payload = {"user_id": userId, "wisata_id": widget.wisata.id};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      print('[FAVORIT] POST status: ${response.statusCode}');
      print('[FAVORIT] POST body: ${response.body}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan ke favorit')),
        );
      }
    } catch (e) {
      print('[ERROR] Saat POST favorit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat menyimpan favorit'),
        ),
      );
    }
  }

  Future<void> _removeFavoriteFromBackend(int userId) async {
    final url = Uri.parse(
      'https://xplore-app-328588022038.asia-southeast2.run.app/api/user/$userId/wisata/favorites/${widget.wisata.id}',
    );
    try {
      final response = await http.delete(url);
      print('[FAVORIT] DELETE status: ${response.statusCode}');
      print('[FAVORIT] DELETE body: ${response.body}');
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus dari favorit')),
        );
      }
    } catch (e) {
      print('[ERROR] Saat DELETE favorit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat menghapus favorit'),
        ),
      );
    }
  }

  Future<void> _loadFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favorite_${widget.wisata.id}';
    setState(() {
      isFavorit = prefs.getBool(key) ?? false;
    });
    print('⭐ Loaded favorit status = $isFavorit');
  }

  List<String> _getImages(String url) {
    if (url.startsWith("http")) return [url];
    return ['https://storage.googleapis.com/xplores/$url'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Detail",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorit ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorit,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSlider(),
            _buildInfo(),
            Expanded(child: _buildBody()),
          ],
        ),
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
      bottomNavigationBar: DiscoverNavBar(
        currentIndex: 0,
        onTabTapped: _navigateToTab,
      ),
    );
  }

  Widget _buildSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (i) => setState(() => _currentImage = i),
                itemBuilder: (_, i) {
                  final imageUrl = Uri.encodeFull(images[i]);
                  print('🖼️ [SLIDER] Memuat gambar ke-$i: $imageUrl');
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        print('✅ [SLIDER] Gambar ke-$i berhasil dimuat');
                        return child;
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ [SLIDER] Gagal memuat gambar ke-$i: $error');
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  );
                },
              ),
              Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentImage == index ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _currentImage == index
                                ? Colors.white
                                : Colors.white54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.wisata.nama,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(widget.wisata.rating.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        16,
        24,
        10,
      ), // Perhatikan 8 di bagian bawah
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        children: [
          const Text(
            "Deskripsi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.wisata.deskripsi),
          const SizedBox(height: 24),
          const Text(
            "Fasilitas Tersedia",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SemuaPenginapanPage()),
              );
            },
            icon: const Icon(Icons.hotel),
            label: const Text("Penginapan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              foregroundColor: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Ringkasan Ulasan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.wisata.rating.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                ],
              ),
              const SizedBox(height: 6),
              RatingBarIndicator(
                rating: widget.wisata.rating,
                itemBuilder:
                    (context, index) =>
                        const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 22.0,
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ReviewListPage(
                            namaWisata: widget.wisata.nama,
                            totalReviews: "2.002 ulasan",
                          ),
                    ),
                  );
                },
                child: const Text(
                  "2.002 ulasan",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (destinasiLainnya.isNotEmpty) ...[
            const Text(
              "Destinasi Lainnya",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: destinasiLainnya.length,
                itemBuilder: (_, index) {
                  final d = destinasiLainnya[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetailWisataPage(
                                wisata: d,
                                semuaDestinasi: widget.semuaDestinasi,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              Uri.encodeFull(d.image),
                              height: 100,
                              width: 140,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  print(
                                    '✅ [LAINNYA] Gambar ${d.id} berhasil dimuat: ${d.image}',
                                  );
                                  return child;
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print(
                                  '❌ [LAINNYA] Gagal memuat gambar ${d.id}: ${d.image} | Error: $error',
                                );
                                return Container(
                                  height: 100,
                                  width: 140,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d.nama,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(d.rating.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
