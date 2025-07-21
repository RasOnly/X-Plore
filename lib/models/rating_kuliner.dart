class RatingKuliner {
  final int id;
  final int userId;
  final int kulinerId;
  final double rating;

  RatingKuliner({
    required this.id,
    required this.userId,
    required this.kulinerId,
    required this.rating,
  });

  factory RatingKuliner.fromJson(Map<String, dynamic> json) {
    return RatingKuliner(
      id: json['id'],
      userId: json['user_id'],
      kulinerId: json['kuliner_id'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
