import 'package:flutter/material.dart';

Widget buildRestoranCard({
  required String title,
  required String imagePath,
  required String rating,
  required String dekat,
}) {
  return Card(
    child: ListTile(
      leading: Image.asset(imagePath),
      title: Text(title),
      subtitle: Text('Rating: $rating\nDekat: $dekat'),
    ),
  );
}
