class UserFavorite {
  final int id;
  final String type; // 'wisata', 'kuliner', atau 'penginapan'
  final String nama;
  final String lokasi;
  final double rating;
  final String image;

  UserFavorite({
    required this.id,
    required this.type,
    required this.nama,
    required this.lokasi,
    required this.rating,
    required this.image,
  });

  factory UserFavorite.fromJson(Map<String, dynamic> json, String type) {
    return UserFavorite(
      id: json['id'],
      type: type,
      nama: json['nama'],
      lokasi: json['lokasi'],
      rating: (json['rating'] as num).toDouble(),
      image: json['image'].startsWith('http')
          ? json['image']
          : 'https://storage.googleapis.com/xplores/${json['image']}',
    );
  }
}
