import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ras/models/wisata.dart';
import 'package:ras/models/kuliner.dart';
import 'package:ras/models/penginapan.dart';
import 'package:ras/pages/detail_restoran.dart';
import 'package:ras/pages/detail_wisata.dart';
import 'package:ras/pages/detail_penginapan.dart';
import 'package:ras/pages/semua_destinasi.dart';
import 'package:ras/pages/semua_restoran.dart';
import 'package:ras/pages/semua_penginapan.dart';
import 'package:ras/services/api_service.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final ApiService _apiService = ApiService();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  String _searchQuery = '';

  late Future<List<Wisata>> _wisataFuture;
  late Future<List<Kuliner>> _kulinerFuture;
  late Future<List<Penginapan>> _penginapanFuture;

  final List<String> sliderImages = [
    'assets/images/slider1.png',
    'assets/images/slider2.png',
    'assets/images/slider3.png',
  ];

  @override
  void initState() {
    super.initState();
    _wisataFuture = _apiService.getAllWisata();
    _kulinerFuture = _apiService.getAllKuliner().then(
      (jsonList) => jsonList.map((json) => Kuliner.fromJson(json)).toList(),
    );
    _penginapanFuture = _apiService.getAllPenginapan();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _currentPage = (_currentPage + 1) % sliderImages.length;
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
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: 204,
            child: PageView.builder(
              controller: _pageController,
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
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          Positioned(
            top: 285,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 60, bottom: 30),
                children: [
                  _sectionTitle(
                    'Destinasi Wisata Populer',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SemuaDestinasiPage(),
                        ),
                      );
                    },
                  ),
                  _buildListFuture<Wisata>(
                    future: _wisataFuture,
                    filter:
                        (item) =>
                            item.nama.toLowerCase().contains(_searchQuery),
                    builder:
                        (item, list) => DetailWisataPage(
                          wisata: item,
                          semuaDestinasi: list,
                        ),
                    horizontal: true,
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(
                    'Restoran Populer',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SemuaRestoranPage(),
                        ),
                      );
                    },
                  ),
                  _buildListFuture<Kuliner>(
                    future: _kulinerFuture,
                    filter:
                        (item) =>
                            item.nama.toLowerCase().contains(_searchQuery),
                    builder:
                        (item, list) => DetailRestoranPage(
                          kuliner: item,
                          semuaRestoran: list,
                        ),
                    horizontal: true,
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(
                    'Penginapan Populer',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SemuaPenginapanPage(),
                        ),
                      );
                    },
                  ),
                  _buildListFuture<Penginapan>(
                    future: _penginapanFuture,
                    filter:
                        (item) =>
                            item.nama.toLowerCase().contains(_searchQuery),
                    builder:
                        (item, list) => DetailPenginapanPage(penginapan: item),
                    horizontal: false,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: MediaQuery.of(context).size.width / 2 - 172,
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
              child: TextField(
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
                decoration: const InputDecoration(
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

  Widget _buildListFuture<T>({
    required Future<List<T>> future,
    required bool Function(T item) filter,
    required Widget Function(T item, List<T> list) builder,
    bool horizontal = true,
  }) {
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final dataList = snapshot.data!.where(filter).toList();
          if (horizontal) {
            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final item = dataList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => builder(item, dataList),
                        ),
                      );
                    },
                    child: _cardItemFromModel(item),
                  );
                },
              ),
            );
          } else {
            return Column(
              children:
                  dataList.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => builder(item, dataList),
                            ),
                          );
                        },
                        child: _verticalCardItem(item),
                      ),
                    );
                  }).toList(),
            );
          }
        }
      },
    );
  }

  Widget _cardItemFromModel(dynamic item) {
    return _cardItem(
      image: item.image,
      title: item.nama,
      rating: item.rating.toString(),
    );
  }

  Widget _cardItem({
    required String image,
    required String title,
    required String rating,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              image,
              height: 100,
              width: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  print('[✅ BERANDA] Gambar berhasil dimuat: $image');
                  return child;
                }
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) {
                print('[❌ BERANDA] Gagal memuat gambar: $image');
                return Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
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
    );
  }

  Widget _verticalCardItem(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              item.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  print('[✅ BERANDA] Gambar berhasil dimuat: ${item.image}');
                  return child;
                }
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) {
                print('[❌ BERANDA] Gagal memuat gambar: ${item.image}');
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(item.rating.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
