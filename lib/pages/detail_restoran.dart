import 'package:flutter/material.dart';
import 'package:ras/models/kuliner.dart';

class DetailRestoranPage extends StatelessWidget {
  final Kuliner kuliner;
  final List<Kuliner> semuaRestoran;

  const DetailRestoranPage({
    super.key,
    required this.kuliner,
    required this.semuaRestoran,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kuliner.nama),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _buildImage(kuliner.image),
            _buildInfo(),
            _buildDeskripsi(),
            _buildRestoranLainnya(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
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
              kuliner.nama,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(kuliner.rating.toString()),
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
        kuliner.deskripsi,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildRestoranLainnya(BuildContext context) {
    final restoranLain =
        semuaRestoran.where((r) => r.id != kuliner.id).take(5).toList();

    if (restoranLain.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restoran Lainnya',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: restoranLain.length,
              itemBuilder: (_, index) {
                final item = restoranLain[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DetailRestoranPage(
                              kuliner: item,
                              semuaRestoran: semuaRestoran,
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
