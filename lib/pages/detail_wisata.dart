import 'package:flutter/material.dart';
import 'discover_page.dart';
import 'favorite.dart';
import 'review_list_page.dart';
import 'semua_destinasi.dart';

class DetailWisataPage extends StatefulWidget {
  final String nama;
  final String image;
  final String rating;
  final List<Map<String, dynamic>> semuaDestinasi; // Tambahkan parameter ini

  const DetailWisataPage({
    super.key,
    required this.nama,
    required this.image,
    required this.rating,
    required this.semuaDestinasi, // Tambahkan ini ke constructor
  });

  @override
  State<DetailWisataPage> createState() => _DetailWisataPageState();
}

class _DetailWisataPageState extends State<DetailWisataPage> {
  late List<String> images;
  int _currentImage = 0;
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> _destinasiLainnya =
      []; // Untuk menyimpan destinasi lainnya

  @override
  void initState() {
    super.initState();
    images = _getImagesForDestination(widget.nama, widget.image);
    _filterDestinasiLainnya(); // Panggil fungsi filter saat inisialisasi
  }

  void _filterDestinasiLainnya() {
    _destinasiLainnya =
        widget.semuaDestinasi
            .where((destinasi) => destinasi['nama'] != widget.nama)
            .toList();
    // Opsional: Batasi jumlah destinasi yang ditampilkan jika terlalu banyak
    if (_destinasiLainnya.length > 5) {
      // Contoh: Hanya tampilkan 5 destinasi
      _destinasiLainnya = _destinasiLainnya.sublist(0, 5);
    }
  }

  List<String> _getImagesForDestination(String nama, String defaultImage) {
    switch (nama) {
      case 'Pantai Tanjung Bira':
        return [
          'assets/images/pantai_bira1.jpg',
          'assets/images/pantai_bira2.jpeg',
          'assets/images/pantai_bira3.jpg',
        ];
      case 'Taman Purbakala Sumpang Bita':
        return ['assets/images/sumpang_bita.png'];
      case 'Negeri Diatas Awan':
        return ['assets/images/negeri_awan.png'];
      default:
        return [defaultImage];
    }
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

  void _goToFavorite() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FavoritePage()));
  }

  @override
  Widget build(BuildContext context) {
    const double sliderHeight = 200;
    const double infoHeight = 70;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.blue, // Warna biru
            fontFamily: 'Poppins', // Gunakan font Poppins
            fontWeight: FontWeight.bold, // Bold sedang (600 = semi-bold)
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.blue),
            onPressed: _goToFavorite,
            tooltip: 'Tambah ke Favorit',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // SLIDER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: sliderHeight,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                                        ? const Color.fromARGB(
                                          255,
                                          254,
                                          254,
                                          254,
                                        )
                                        : const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
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
            ),
            // INFO DESTINASI
            Container(
              height: infoHeight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getLokasi(widget.nama),
                              style: const TextStyle(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '(2.002 ulasan)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 14, 16),
                  children: [
                    // Deskripsi
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getDeskripsi(widget.nama),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.5,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Fasilitas
                    const Text(
                      'Fasilitas Tersedia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        fasilitasItem(Icons.hotel, 'Penginapan'),
                        fasilitasItem(Icons.restaurant, 'Restoran'),
                        fasilitasItem(
                          Icons.grid_view_rounded,
                          'Aktivitas &\nHiburan',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Ringkasan Ulasan
                    const Text(
                      'Ringkasan Ulasan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bar chart ulasan (hanya sampai tengah)
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(5, (i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${5 - i}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.amber[400],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        // Bar hanya sampai tengah
                                        width: (5 - i) * 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                        // Rating dan ulasan di kanan
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.rating,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 2),
                                  InkWell(
                                    // Menggunakan InkWell untuk efek visual yang lebih baik
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ReviewListPage(
                                                namaWisata: widget.nama,
                                                totalReviews:
                                                    '2.002 ulasan', // Kirim teks ulasan lengkap
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      '2.002 ulasan', // Mengubah teks dari '(2.002 ulasan)' menjadi '2.002 ulasan'
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        decoration:
                                            TextDecoration
                                                .underline, // Opsional: tambahkan underline untuk menunjukkan dapat diklik
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Destinasi Wisata Lainnya
                    if (_destinasiLainnya.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Destinasi Wisata Lainnya',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const SemuaDestinasiPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Lihat Semua',
                                  style: TextStyle(
                                    color: Colors.blue[400],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180, // Sesuaikan tinggi sesuai kebutuhan
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _destinasiLainnya.length,
                              itemBuilder: (context, index) {
                                final item = _destinasiLainnya[index];
                                return GestureDetector(
                                  onTap: () {
                                    // Navigasi ke DetailWisataPage dari destinasi lain
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailWisataPage(
                                              nama: item['nama'],
                                              image: item['image'],
                                              rating: item['rating'],
                                              semuaDestinasi:
                                                  widget
                                                      .semuaDestinasi, // Teruskan lagi semua destinasi
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 150, // Lebar setiap item
                                    margin: const EdgeInsets.only(right: 16),
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
                                          child: Image.asset(
                                            item['image'],
                                            height: 100, // Tinggi gambar
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
                                              fontFamily: 'Poppins',
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
                  ],
                ),
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

  String _getLokasi(String nama) {
    switch (nama) {
      case 'Pantai Tanjung Bira':
        return 'Bira, Bulukumba';
      case 'Taman Purbakala Sumpang Bita':
        return 'Pangkep, Sulawesi Selatan';
      case 'Negeri Diatas Awan':
        return 'Kab. Gowa';
      default:
        return '-';
    }
  }

  String _getDeskripsi(String nama) {
    switch (nama) {
      case 'Pantai Tanjung Bira':
        return 'Pantai Tanjung Bira adalah salah satu destinasi wisata terkenal di Sulawesi Selatan yang terletak di Kabupaten Bulukumba, sekitar 200 km dari Kota Makassar. Pantai ini dikenal dengan pasir putihnya yang halus seperti tepung, air laut yang jernih dengan gradasi warna biru yang menawan.';
      case 'Taman Purbakala Sumpang Bita':
        return 'Taman Purbakala Sumpang Bita adalah situs purbakala yang memiliki nilai sejarah tinggi, terletak di Kabupaten Pangkep, Sulawesi Selatan. Tempat ini menyimpan banyak peninggalan prasejarah berupa lukisan dinding dan artefak.';
      case 'Negeri Diatas Awan':
        return 'Negeri Diatas Awan adalah destinasi wisata alam di Kabupaten Gowa yang menawarkan pemandangan awan di atas pegunungan, sangat cocok untuk menikmati sunrise dan suasana sejuk.';
      default:
        return 'Deskripsi belum tersedia.';
    }
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
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
