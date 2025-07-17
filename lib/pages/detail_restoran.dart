import 'package:flutter/material.dart';
import 'discover_page.dart';
import 'favorite.dart';
import 'review_list_restoran.dart';
import 'semua_restoran.dart';

class DetailRestoranPage extends StatefulWidget {
  final String nama;
  final String image; // Ini akan menjadi gambar utama untuk preview
  final String rating;
  final String dekat; // Parameter untuk lokasi terdekat/spesialisasi
  // Tambahkan parameter untuk menerima seluruh daftar restoran
  final List<Map<String, dynamic>> semuaRestoran;

  const DetailRestoranPage({
    super.key,
    required this.nama,
    required this.image,
    required this.rating,
    this.dekat = '', // Default kosong jika tidak selalu ada
    required this.semuaRestoran, // Pastikan ini required
  });

  @override
  State<DetailRestoranPage> createState() => _DetailRestoranPageState();
}

class _DetailRestoranPageState extends State<DetailRestoranPage> {
  late List<String> images;
  int _currentImage = 0;
  final PageController _pageController = PageController();
  bool _showFullDesc = false;

  @override
  void initState() {
    super.initState();
    // Dapatkan daftar gambar untuk restoran ini
    images = _getImagesForRestaurant(widget.nama, widget.image);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  // Fungsi untuk mendapatkan daftar gambar berdasarkan nama restoran
  List<String> _getImagesForRestaurant(String nama, String defaultImage) {
    switch (nama) {
      case 'RM Seafood Apong':
        return [
          'assets/images/seafood_apong.png',
          'assets/images/seafood_apong_2.png', // Tambahkan gambar lain jika ada
          'assets/images/seafood_apong_3.png',
        ];
      case 'Coto Nusantara':
        return [
          'assets/images/coto_nusantara.png',
          'assets/images/coto_nusantara_2.png',
          'assets/images/coto_nusantara_3.png',
        ];
      case 'Pallubasa Serigala':
        return [
          'assets/images/pallubasa_serigala.png',
          'assets/images/pallubasa_serigala_2.png',
        ];
      case 'Konro Karebosi':
        return [
          'assets/images/konro_karebosi.png',
          'assets/images/konro_karebosi_2.png',
        ];
      case 'Warung Makan Coto Makassar Daeng Liwang':
        return ['assets/images/coto_daeng_liwang.png'];
      case 'Rumah Makan Bravo':
        return ['assets/images/rumah_makan_bravo.png'];
      case 'Sop Saudara Irian':
        return ['assets/images/sop_saudara_irian.png'];
      case 'Ayam Goreng Sulawesi':
        return ['assets/images/ayam_goreng_sulawesi.png'];
      case 'Bakso Ati Raja':
        return ['assets/images/bakso_ati_raja.png'];
      case 'Mie Titi':
        return ['assets/images/mie_titi.png'];
      case 'Rumah Makan Losari':
        return ['assets/images/rumah_makan_losari.png'];
      case 'RM Muda Mudi':
        return ['assets/images/rm_muda_mudi.png'];
      case 'Warung Coto Gagak':
        return ['assets/images/warung_coto_gagak.png'];
      default:
        return [
          defaultImage,
        ]; // Kembali ke gambar default jika tidak ada di list
    }
  }

  // Fungsi untuk mendapatkan deskripsi restoran (dari data statis, seperti sebelumnya)
  String _getDeskripsiRestoran(String namaRestoran) {
    switch (namaRestoran) {
      case 'RM Seafood Apong':
        return 'RM Seafood Apong adalah restoran seafood legendaris di Makassar yang terkenal dengan hidangan laut segarnya, seperti ikan bakar, udang, kepiting, dan cumi. Rasakan cita rasa bumbu khas Makassar yang meresap sempurna dalam setiap hidangannya. Tempat yang tepat untuk menikmati makan malam bersama keluarga atau teman.';
      case 'Coto Nusantara':
        return 'Coto Nusantara menyajikan Coto Makassar dengan resep tradisional yang diwariskan turun-temurun. Kuahnya yang kental, gurih, dan kaya rempah, berpadu dengan irisan daging sapi pilihan dan jeroan. Nikmati pengalaman kuliner autentik Makassar di sini.';
      case 'Pallubasa Serigala':
        return 'Pallubasa Serigala adalah salah satu tempat terbaik untuk menikmati Pallubasa, kuliner khas Makassar yang unik. Hidangan ini berupa semacam soto dengan kuah berwarna kecoklatan yang kental, terbuat dari jeroan sapi dan daging, disajikan dengan telur mentah yang diaduk di atasnya. Rasanya kaya, gurih, dan sangat menggugah selera.';
      case 'Konro Karebosi':
        return 'Konro Karebosi terkenal dengan Sop Konro dan Konro Bakar, hidangan iga sapi khas Makassar yang empuk dan kaya rasa. Sop Konro disajikan dengan kuah rempah yang kental, sedangkan Konro Bakar disajikan dengan bumbu kacang yang manis gurih. Wajib dicoba bagi pecinta iga sapi.';
      case 'Warung Makan Coto Makassar Daeng Liwang':
        return 'Warung Makan Coto Makassar Daeng Liwang adalah salah satu tempat favorit warga lokal untuk menikmati Coto Makassar. Dikenal dengan kuah yang mantap dan porsi yang mengenyangkan, tempat ini selalu ramai pengunjung. Sempurna untuk sarapan atau makan siang.';
      case 'Rumah Makan Bravo':
        return 'Rumah Makan Bravo menyajikan aneka hidangan khas Sulawesi dengan cita rasa rumahan. Dari sayur asem, ikan pallumara, hingga ayam goreng, semua disajikan dengan bumbu yang kaya dan segar. Suasana yang nyaman cocok untuk santap siang bersama keluarga.';
      case 'Sop Saudara Irian':
        return 'Sop Saudara Irian adalah salah satu kuliner legendaris di Makassar. Sop ini memiliki kuah bening yang kaya rempah dengan isian daging sapi, bihun, dan perkedel kentang. Rasa gurih dan segar dari sop ini sangat cocok dinikmati kapan saja.';
      case 'Ayam Goreng Sulawesi':
        return 'Ayam Goreng Sulawesi menyajikan ayam goreng dengan bumbu khas yang meresap hingga ke tulang. Disajikan dengan nasi hangat dan sambal pedas, hidangan ini menjadi favorit banyak orang. Tekstur ayam yang renyah di luar dan lembut di dalam akan memanjakan lidah Anda.';
      case 'Bakso Ati Raja':
        return 'Bakso Ati Raja adalah salah satu bakso paling populer di Makassar. Dikenal dengan tekstur baksonya yang kenyal, kuah kaldu yang gurih, dan pilihan topping yang beragam. Rasakan kelezatan bakso khas kota ini.';
      case 'Mie Titi':
        return 'Mie Titi adalah hidangan mie kering khas Makassar yang disiram dengan kuah kental berisi daging, seafood, dan sayuran. Mie Titi menawarkan perpaduan tekstur renyah dari mie kering dan lembutnya kuah gurih. Wajib dicoba bagi pecinta mie.';
      case 'Rumah Makan Losari':
        return 'Rumah Makan Losari menawarkan berbagai masakan Indonesia dengan spesialisasi hidangan laut. Dengan lokasi strategis dekat Pantai Losari, Anda bisa menikmati hidangan lezat sambil menikmati pemandangan laut.';
      case 'RM Muda Mudi':
        return 'RM Muda Mudi adalah restoran yang cocok untuk kumpul bersama teman dan keluarga, menyajikan hidangan Indonesia populer dengan harga terjangkau. Suasana santai dan pilihan menu yang beragam menjadikan tempat ini pilihan yang baik.';
      case 'Warung Coto Gagak':
        return 'Warung Coto Gagak adalah salah satu warung coto tertua dan paling terkenal di Makassar. Coto Makassar di sini terkenal dengan kuahnya yang pekat, gurih, dan rempahnya yang kuat. Pastikan untuk mencoba pengalaman kuliner yang autentik di sini.';
      default:
        return 'Deskripsi untuk restoran ini belum tersedia. Nikmati hidangan lezat dan suasana nyaman di sini!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRestoranLainnya =
        widget.semuaRestoran
            .where((restoran) => restoran['nama'] != widget.nama)
            .toList();

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
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Tambahkan logika favorit di sini
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Tambahkan logika berbagi di sini
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Slider
            Stack(
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
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
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        images.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap:
                                () => _pageController.animateToPage(
                                  entry.key,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                ),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(
                                  _currentImage == entry.key ? 0.9 : 0.4,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Restoran dan Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.nama,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Lokasi Terdekat
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lokasi: ${widget.dekat}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDescriptionText(widget.nama),
                  const SizedBox(height: 20),

                  // Fasilitas
                  Text(
                    'Fasilitas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height:
                        100, // Sesuaikan tinggi agar item fasilitas tidak terpotong
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        fasilitasItem(Icons.wifi, 'Wi-Fi'),
                        fasilitasItem(Icons.local_parking, 'Parkir'),
                        fasilitasItem(Icons.restaurant_menu, 'Menu Lengkap'),
                        fasilitasItem(Icons.child_care, 'Area Anak'),
                        fasilitasItem(Icons.smoking_rooms, 'Smoking Area'),
                        fasilitasItem(Icons.credit_card, 'Pembayaran Digital'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ulasan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ulasan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.grey[800],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman daftar ulasan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ReviewListPage(
                                    namaRestoran: widget.nama,
                                    semuaRestoran: widget.semuaRestoran,
                                  ),
                            ),
                          );
                        },
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
                  const SizedBox(height: 10),
                  // Contoh Ulasan Singkat (bisa diganti dengan data ulasan nyata)
                  _buildReviewCard(
                    'John Doe',
                    'assets/images/user1.png', // Ganti dengan gambar user
                    'Restoran ini luar biasa! Makanannya enak dan pelayanannya cepat.',
                    '5.0',
                  ),
                  const SizedBox(height: 10),
                  _buildReviewCard(
                    'Jane Smith',
                    'assets/images/user2.png', // Ganti dengan gambar user
                    'Suasana nyaman, makanan lezat. Sangat direkomendasikan.',
                    '4.8',
                  ),
                  const SizedBox(height: 20),

                  // Restoran Lainnya
                  Text(
                    'Restoran Lainnya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 140, // Tinggi untuk daftar restoran lainnya
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredRestoranLainnya.length,
                      itemBuilder: (context, index) {
                        final restoran = filteredRestoranLainnya[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: _restoranLainItem(
                            restoran['image'],
                            restoran['nama'],
                            restoran['rating'],
                            restoran['lokasi'],
                            widget
                                .semuaRestoran, // Teruskan juga daftar lengkap
                          ),
                        );
                      },
                    ),
                  ),
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

  // Widget untuk menampilkan deskripsi dengan opsi 'selengkapnya'
  Widget _buildDescriptionText(String namaRestoran) {
    final fullDesc = _getDeskripsiRestoran(namaRestoran);
    final shortDesc =
        fullDesc.length > 150 ? fullDesc.substring(0, 150) + '...' : fullDesc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showFullDesc ? fullDesc : shortDesc,
          style: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
        ),
        if (!_showFullDesc && fullDesc.length > 150)
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

  // Widget untuk item fasilitas
  Widget fasilitasItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
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
      ),
    );
  }

  // Widget untuk kartu ulasan
  Widget _buildReviewCard(
    String reviewerName,
    String avatarPath,
    String reviewText,
    String rating,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: AssetImage(avatarPath)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reviewText,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget untuk item 'Restoran Lainnya'
  Widget _restoranLainItem(
    String img,
    String nama,
    String rating,
    String lokasi,
    List<Map<String, dynamic>> semuaRestoran,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetailRestoranPage(
                  nama: nama,
                  image: img,
                  rating: rating,
                  dekat: lokasi,
                  semuaRestoran: semuaRestoran, // Teruskan daftar lengkap
                ),
          ),
        );
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                img,
                height: 80,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              nama,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(rating, style: const TextStyle(fontSize: 11)),
              ],
            ),
            Text(
              lokasi,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
