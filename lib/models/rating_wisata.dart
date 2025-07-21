class RatingWisata {
  final int id;
  final int userId;
  final int wisataId;
  final double rating;

  RatingWisata({
    required this.id,
    required this.userId,
    required this.wisataId,
    required this.rating,
  });

  factory RatingWisata.fromJson(Map<String, dynamic> json) {
    return RatingWisata(
      id: json['id'],
      userId: json['user_id'],
      wisataId: json['wisata_id'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
