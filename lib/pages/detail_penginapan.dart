import 'package:flutter/material.dart';
import 'discover_page.dart';

class DetailPenginapanPage extends StatefulWidget {
  final String nama;
  final String image;
  final String rating;
  final String dekat;

  const DetailPenginapanPage({
    super.key,
    required this.nama,
    required this.image,
    required this.rating,
    required this.dekat,
  });

  @override
  State<DetailPenginapanPage> createState() => _DetailPenginapanPageState();
}

class _DetailPenginapanPageState extends State<DetailPenginapanPage> {
  bool _showFullDesc = false;

  void _navigateToTab(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DiscoverPage(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blue),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Gambar utama (tetap di atas, tidak ikut scroll)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  widget.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Expanded: bagian yang bisa di-scroll
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Nama, lokasi, rating
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.place,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.dekat,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            Text(
                              widget.rating,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '(478 ulasan)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 24,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                  // Deskripsi
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDeskripsi(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Fasilitas
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fasilitas Tersedia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            fasilitasItem(Icons.place, 'Destinasi\nWisata'),
                            fasilitasItem(Icons.restaurant, 'Restoran'),
                            fasilitasItem(
                              Icons.grid_view_rounded,
                              'Aktivitas &\nHiburan',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Ringkasan Ulasan
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan Ulasan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _reviewSummary(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              widget.rating,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '2.002 ulasan',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 32,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                  // Destinasi Wisata Lainnya (dummy)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Destinasi Wisata Lainnya',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _wisataLainItem(
                          'assets/images/bira.png',
                          'Pantai Tanjung Bira',
                        ),
                        const SizedBox(width: 12),
                        _wisataLainItem(
                          'assets/images/aryaduta.png',
                          'Hotel Aryaduta',
                        ),
                        // Tambahkan item lain sesuai kebutuhan
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
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

  Widget fasilitasItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue[50],
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _reviewSummary() {
    // Dummy bar chart ulasan
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (i) {
        double percent = [0.7, 0.5, 0.3, 0.1, 0.05][i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Text('${5 - i}'),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == 0 ? Colors.amber : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: 120 * percent,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDeskripsi() {
    final fullDesc =
        'Bara Beach Bungalows adalah resor butik yang terletak di Pantai Bara, Bira, Sulawesi Selatan, menawarkan suasana tenang dan pemandangan langsung ke Laut Flores. Resor ini menyediakan berbagai tipe kamar ber-AC dengan pemandangan taman, dilengkapi dengan meja kerja, lemari pakaian, kulkas, dan kamar mandi pribadi.';
    final shortDesc =
        fullDesc.length > 120 ? fullDesc.substring(0, 120) + '...' : fullDesc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showFullDesc ? fullDesc : shortDesc,
          style: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
        ),
        if (!_showFullDesc && fullDesc.length > 120)
          GestureDetector(
            onTap: () => setState(() => _showFullDesc = true),
            child: const Text(
              'selengkapnya',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _wisataLainItem(String img, String nama) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(img, height: 70, width: 140, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(
            nama,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
