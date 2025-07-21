class RatingPenginapan {
  final int id;
  final int userId;
  final int penginapanId;
  final double rating;

  RatingPenginapan({
    required this.id,
    required this.userId,
    required this.penginapanId,
    required this.rating,
  });

  factory RatingPenginapan.fromJson(Map<String, dynamic> json) {
    return RatingPenginapan(
      id: json['id'],
      userId: json['user_id'],
      penginapanId: json['penginapan_id'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
