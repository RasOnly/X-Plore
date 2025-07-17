// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ras/pages/discover_page.dart'; // pastikan path ini benar

void main() {
  testWidgets('App loads DiscoverPage', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DiscoverPage()));
    await tester.pumpAndSettle(); // pastikan semua widget selesai dirender

    // Pastikan teks "Beranda" memang ada di halaman utama
    expect(find.text('Beranda'), findsOneWidget);
  });
}
