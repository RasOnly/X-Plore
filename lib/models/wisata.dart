class Wisata {
  final int id;
  final List<String> foto;
  final String nama;
  final String lokasi;
  final String deskripsi;
  final double rating;

  Wisata({
    required this.id,
    required this.foto,
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.rating,
  });

  factory Wisata.fromJson(Map<String, dynamic> json) {
    return Wisata(
      id: json['id_wisata'] ?? 0, // Pastikan ini sesuai nama field backend
      foto: List<String>.from(json['foto_wisata'] ?? []),
      nama: json['nama_wisata'] ?? 'Nama tidak tersedia',
      lokasi: json['lokasi_wisata'] ?? 'Lokasi tidak tersedia',
      deskripsi: json['deskripsi'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_wisata': id,
    'foto_wisata': foto,
    'nama_wisata': nama,
    'lokasi_wisata': lokasi,
    'deskripsi': deskripsi,
    'rating': rating,
  };

  // Akses gambar pertama
  String get image {
    if (foto.isEmpty) return 'https://via.placeholder.com/150';
    return foto.first.startsWith('http')
        ? foto.first
        : 'https://storage.googleapis.com/xplores/${foto.first}';
  }
}
