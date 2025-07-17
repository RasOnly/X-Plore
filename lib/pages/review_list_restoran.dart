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

class ReviewListPage extends StatefulWidget {
  // <-- Ubah ke StatefulWidget
  final String namaRestoran; // <-- Ubah dari namaWisata ke namaRestoran
  final List<Map<String, dynamic>> semuaRestoran; // <-- Tambahkan parameter ini

  const ReviewListPage({
    super.key,
    required this.namaRestoran,
    required this.semuaRestoran, // <-- Inisialisasi di konstruktor
  });

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  // Data dummy ulasan untuk demonstrasi
  // Di aplikasi nyata, data ini akan diambil dari API atau database
  // Anda bisa menyesuaikan ulasan ini agar spesifik untuk namaRestoran
  List<Review> get _dummyReviews {
    // Filter ulasan dummy berdasarkan namaRestoran jika Anda memiliki data ulasan yang lebih spesifik
    // Untuk contoh ini, saya akan menampilkan beberapa ulasan generik
    return [
      Review(
        reviewerName: 'Budi Santoso',
        date: '1 hari yang lalu',
        reviewText:
            'Makanan di ${widget.namaRestoran} sangat lezat, terutama ${widget.namaRestoran == 'RM Seafood Apong' ? 'ikan bakarnya!' : 'hidangan utamanya'}. Suasana juga nyaman dan pelayanan cepat. Sangat direkomendasikan!',
        avatarAsset: 'assets/images/avatar1.png', // Contoh avatar
        rating: 4.5,
      ),
      Review(
        reviewerName: 'Citra Dewi',
        date: '3 hari yang lalu',
        reviewText:
            'Saya sangat menikmati kunjungan saya. ${widget.namaRestoran} punya hidangan yang otentik dan bumbu yang kuat. Pasti akan kembali lagi!',
        avatarAsset: 'assets/images/avatar2.png',
        rating: 5.0,
      ),
      Review(
        reviewerName: 'Agus Salim',
        date: 'Seminggu yang lalu',
        reviewText:
            'Lumayan, tapi porsinya sedikit kecil untuk harga segitu. Rasanya enak.',
        avatarAsset: null, // Tanpa avatar
        rating: 3.5,
      ),
    ];
  }

  // Hitung total rating dan persentase untuk bar rating
  Map<int, int> _getRatingCounts() {
    Map<int, int> counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var review in _dummyReviews) {
      int star = review.rating.floor();
      if (star >= 1 && star <= 5) {
        counts[star] = (counts[star] ?? 0) + 1;
      }
    }
    return counts;
  }

  double _getAverageRating() {
    if (_dummyReviews.isEmpty) return 0.0;
    double total = _dummyReviews.fold(
      0.0,
      (sum, review) => sum + review.rating,
    );
    return total / _dummyReviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final ratingCounts = _getRatingCounts();
    final totalReviews = _dummyReviews.length;
    final averageRating = _getAverageRating();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ulasan ${widget.namaRestoran}', // Menggunakan namaRestoran
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Rating
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < averageRating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          );
                        }),
                      ),
                      Text(
                        '${totalReviews} Ulasan',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Detail Bar Rating
              ...List.generate(5, (index) {
                final star = 5 - index; // 5, 4, 3, 2, 1
                final count = ratingCounts[star] ?? 0;
                final percentage =
                    totalReviews > 0 ? count / totalReviews : 0.0;
                return _buildRatingBar(star, percentage);
              }),
              const Divider(height: 40, thickness: 1),
              // Daftar Ulasan
              Text(
                'Semua Ulasan (${totalReviews})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap:
                    true, // Penting karena berada di dalam SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Nonaktifkan scroll ListView
                itemCount: _dummyReviews.length,
                itemBuilder: (context, index) {
                  final review = _dummyReviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    review.avatarAsset != null
                                        ? AssetImage(review.avatarAsset!)
                                        : null,
                                child:
                                    review.avatarAsset == null
                                        ? Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )
                                        : null,
                                backgroundColor:
                                    review.avatarAsset == null
                                        ? Colors.blueGrey
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
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      review.date,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  Text(
                                    review.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            review.reviewText,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
