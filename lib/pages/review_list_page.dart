import 'package:flutter/material.dart';

// Model untuk merepresentasikan satu ulasan
class Review {
  final String reviewerName;
  final String date;
  final String reviewText;
  final String? avatarAsset; // Path ke aset gambar avatar (opsional)
  final double rating; // Rating bintang untuk ulasan ini

  Review({
    required this.reviewerName,
    required this.date,
    required this.reviewText,
    this.avatarAsset,
    required this.rating,
  });
}

class ReviewListPage extends StatelessWidget {
  final String namaWisata;
  final String totalReviews;

  const ReviewListPage({
    super.key,
    required this.namaWisata,
    required this.totalReviews,
  });
  
  // Data dummy ulasan untuk demonstrasi
  // Di aplikasi nyata, data ini akan diambil dari API atau database
  List<Review> get _dummyReviews {
    return [
      Review(
        reviewerName: 'Arya',
        date: '2 hari yang lalu',
        reviewText:
            'Pantai Tanjung Bira menawarkan pasir putih halus dan air laut yang jernih, menjadikannya destinasi yang indah untuk bersantai atau snorkeling. Pemandangan matahari terbit dan terbenam di sini benar-benar menakjubkan. Namun, saat musim liburan, pantai bisa cukup ramai, dan beberapa fasilitas seperti toilet atau area parkir perlu perbaikan agar lebih nyaman bagi wisatawan. Meskipun demikian, keindahan alamnya tetap membuat tempat ini layak dikunjungi.',
        avatarAsset:
            'assets/avatars/avatar1.png', // Ganti dengan path aset avatar yang sesuai
        rating: 4.5,
      ),
      Review(
        reviewerName: 'Iqbal',
        date: '19-03-2025',
        reviewText:
            'Pantai Tanjung Bira memiliki pasir putih yang indah dan air laut yang jernih, cocok untuk berenang atau snorkeling. Namun, kebersihan di beberapa area kurang terjaga, terutama di sekitar fasilitas umum. Selain itu, akses jalan menuju pantai perlu diperbaiki karena ada beberapa bagian yang kurang mulus. Saat musim liburan, pantai bisa sangat ramai, sehingga kurang nyaman untuk bersantai. Secara keseluruhan, tempat ini menarik untuk dikunjungi, tetapi masih ada beberapa hal yang bisa ditingkatkan.',
        avatarAsset:
            'assets/avatars/avatar2.png', // Ganti dengan path aset avatar yang sesuai
        rating: 4.0,
      ),
      Review(
        reviewerName: 'Dinda',
        date: '10-03-2025',
        reviewText:
            'Pantai Tanjung Bira benar-benar luar biasa! Pasirnya putih dan halus seperti tepung, air lautnya sangat jernih dengan gradasi warna biru yang menakjubkan. Suasana di sini sangat tenang, cocok untuk bersantai atau menikmati matahari terbit dan terbenam yang spektakuler. Selain itu, aktivitas seperti snorkeling dan diving di sekitar Pulau Liukang Loe benar-benar memukau dengan keindahan terumbu karangnya. Fasilitas wisata cukup lengkap, banyak penginapan dan tempat makan di sekitar pantai. Saya sangat merekomendasikan tempat ini bagi siapa pun yang mencari liburan pantai yang sempurna!',
        avatarAsset:
            'assets/avatars/avatar3.png', // Ganti dengan path aset avatar yang sesuai
        rating: 5.0,
      ),
      Review(
        reviewerName: 'Damar',
        date: '27-02-2025',
        reviewText:
            'Pantai dengan pasir putih dan pemandangan yang indah. Jika memiliki budget lebih, lebih baik pilih resort/bungalow yang memiliki akses private beach.',
        avatarAsset:
            'assets/avatars/avatar4.png', // Ganti dengan path aset avatar yang sesuai
        rating: 4.0,
      ),
      Review(
        reviewerName: 'Citra',
        date: '20-02-2025',
        reviewText:
            'Tempat yang indah untuk bersantai, tapi agak ramai di akhir pekan. Overall, pengalaman yang menyenangkan.',
        avatarAsset:
            'assets/avatars/avatar5.png', // Ganti dengan path aset avatar yang sesuai
        rating: 3.5,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Ulasan ${namaWisata.length > 15 ? namaWisata.substring(0, 12) + '...' : namaWisata}', // Memotong nama jika terlalu panjang
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Ulasan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Rating Summary Bar (seperti di DetailWisataPage, tapi dengan data statis)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRatingBar(5, 0.9), // Contoh data dummy
                            _buildRatingBar(4, 0.7),
                            _buildRatingBar(3, 0.4),
                            _buildRatingBar(2, 0.2),
                            _buildRatingBar(1, 0.1),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              // Menggunakan rating dari DetailWisataPage atau ambil rata-rata dari dummyReviews
                              totalReviews.split(
                                ' ',
                              )[0], // Ambil hanya angka rating
                              style: const TextStyle(
                                fontSize: 28,
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
                                Text(
                                  totalReviews, // Menampilkan teks ulasan lengkap
                                  style: const TextStyle(
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
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1), // Garis pemisah
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _dummyReviews.length,
                itemBuilder: (context, index) {
                  final review = _dummyReviews[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    review.avatarAsset != null
                                        ? AssetImage(review.avatarAsset!)
                                        : null,
                                child:
                                    review.avatarAsset == null
                                        ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )
                                        : null,
                                backgroundColor:
                                    review.avatarAsset == null
                                        ? Colors.grey
                                        : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.reviewerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      review.date,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber[400],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    review.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            review.reviewText,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              fontFamily: 'Poppins',
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
    );
  }

  // Widget pembantu untuk membangun bar rating individual
  Widget _buildRatingBar(int star, double fillPercentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$star',
            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: fillPercentage, // Mengisi bar sesuai persentase
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
