class Ulasan {
  final int id;
  final int userId;
  final int wisataId;
  final String komentar;

  Ulasan({
    required this.id,
    required this.userId,
    required this.wisataId,
    required this.komentar,
  });

  factory Ulasan.fromJson(Map<String, dynamic> json) {
    return Ulasan(
      id: json['id'],
      userId: json['user_id'],
      wisataId: json['wisata_id'],
      komentar: json['komentar'],
    );
  }
}
