class Penginapan {
  final int id;
  final List<String> foto;
  final String nama;
  final String lokasi;
  final String deskripsi;
  final double rating;

  Penginapan({
    required this.id,
    required this.foto,
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.rating,
  });

  factory Penginapan.fromJson(Map<String, dynamic> json) {
    return Penginapan(
      id: json['id_penginapan'],
      foto: List<String>.from(json['foto_penginapan']),
      nama: json['nama_penginapan'],
      lokasi: json['lokasi_penginapan'],
      deskripsi: json['deskripsi'],
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  String get image {
    if (foto.isEmpty) {
      return 'https://via.placeholder.com/300x200.png?text=No+Image';
    }

    final rawUrl = foto.first;
    // Encode seluruh URL jika mengandung spasi atau karakter khusus
    final uri = Uri.parse(rawUrl);
    final encoded = Uri.encodeFull(uri.toString());

    return encoded;
  }
}
