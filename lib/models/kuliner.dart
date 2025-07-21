class Kuliner {
  final int id;
  final List<String> foto;
  final String nama;
  final String lokasi;
  final String deskripsi;
  final double rating;

  Kuliner({
    required this.id,
    required this.foto,
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.rating,
  });

  factory Kuliner.fromJson(Map<String, dynamic> json) {
    return Kuliner(
      id: json['id_kuliner'],
      foto: List<String>.from(json['foto_kuliner']),
      nama: json['nama_kuliner'],
      lokasi: json['lokasi_kuliner'],
      deskripsi: json['deskripsi'],
      rating: (json['rating'] ?? 0).toDouble(), // ✅ default 0 kalau null
    );
  }

  String get image =>
      foto.isNotEmpty
          ? (foto.first.startsWith('http')
              ? foto.first
              : 'https://storage.googleapis.com/xplores/${foto.first}')
          : '';
}
