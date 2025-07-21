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
      id: json['id_wisata'],
      foto: List<String>.from(json['foto_wisata']),
      nama: json['nama_wisata'],
      lokasi: json['lokasi_wisata'],
      deskripsi: json['deskripsi'],
      rating: 0.0, // Karena belum tersedia di API
    );
  }

  String get image {
    if (foto.isEmpty) return 'https://via.placeholder.com/150';
    return foto.first.startsWith('http')
        ? foto.first
        : 'https://storage.googleapis.com/xplores/${foto.first}';
  }
}
