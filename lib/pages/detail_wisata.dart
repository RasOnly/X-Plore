import 'package:flutter/material.dart';
import 'package:ras/models/wisata.dart';
import 'package:ras/pages/review_list_page.dart';
import 'package:ras/pages/discover_page.dart';
import 'package:ras/pages/favorite.dart';

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
  late List<String> images;
  late List<Wisata> destinasiLainnya;
  int _currentImage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    images = _getImages(widget.wisata.nama, widget.wisata.image);

    destinasiLainnya =
        widget.semuaDestinasi
            .where((w) => w.id != widget.wisata.id)
            .take(5)
            .toList();
  }

  List<String> _getImages(String nama, String imageUrl) {
    if (imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return [imageUrl];
      } else {
        return ['https://storage.googleapis.com/xplores/$imageUrl'];
      }
    }

    // Fallback image lokal jika kosong
    return ['assets/images/default.jpg'];
  }

  void _navigateToTab(int index) {
    if (index == 2 || index == 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fitur ini belum tersedia')));
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DiscoverPage(initialIndex: index)),
      (route) => false,
    );
  }

  void _goToFavorite() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FavoritePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wisata.nama),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: _goToFavorite,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _buildImageSlider(),
            _buildInfo(),
            _buildDeskripsi(),
            _buildUlasanRingkasan(),
            _buildDestinasiLainnya(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) => setState(() => _currentImage = index),
                itemBuilder: (_, i) {
                  final image = images[i];
                  return image.startsWith('http')
                      ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder:
                            (_, __, ___) => const Icon(Icons.broken_image),
                      )
                      : Image.asset(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                },
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    return AnimatedContainer(
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
                    );
                  }),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.wisata.nama,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildDeskripsi() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        widget.wisata.deskripsi,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildUlasanRingkasan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Icon(Icons.reviews, color: Colors.blue),
          const SizedBox(width: 8),
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
              'Lihat ulasan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinasiLainnya() {
    if (destinasiLainnya.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Destinasi Lainnya',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: destinasiLainnya.length,
              itemBuilder: (_, index) {
                final item = destinasiLainnya[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DetailWisataPage(
                              wisata: item,
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
                            item.image,
                            height: 100,
                            width: 140,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
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
                            Text(item.rating.toString()),
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
      ),
    );
  }
}
