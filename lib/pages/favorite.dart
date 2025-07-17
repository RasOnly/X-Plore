import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _selectedCategory = 0;

  final List<String> categories = [
    'Semua Kategori',
    'Destinasi Wisata',
    'Restoran',
    'Penginapan',
  ];

  final List<Map<String, dynamic>> items = [
    {
      'type': 'Destinasi Wisata',
      'title': 'Taman Purbakala Sumpang bita',
      'rating': 4.6,
      'location': 'Pangkep',
      'image': 'assets/images/sumpang_bita.png',
    },
    {
      'type': 'Restoran',
      'title': "d'Perahu Resto",
      'rating': 4.6,
      'location': 'Bira, Bulukumba',
      'image': 'assets/images/restoran1.png',
    },
    {
      'type': 'Penginapan',
      'title': 'Bara Beach Bungalows',
      'rating': 4.6,
      'location': 'Bira, Bulukumba',
      'image': 'assets/images/penginapan1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter items sesuai kategori
    List<Map<String, dynamic>> filteredItems =
        _selectedCategory == 0
            ? items
            : items
                .where((item) => item['type'] == categories[_selectedCategory])
                .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF61A9F9),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Semua Item terfavorit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Kategori
          Container(
            color: const Color(0xFF61A9F9),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final bool selected = _selectedCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        categories[index],
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: selected,
                      selectedColor: Colors.blue,
                      backgroundColor: Colors.white,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = index;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: selected ? Colors.blue : Colors.blue.shade100,
                        ),
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  );
                }),
              ),
            ),
          ),
          // List Favorit
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
              itemCount: filteredItems.length,
              separatorBuilder:
                  (_, __) =>
                      const Divider(height: 18, color: Color(0xFFE0E0E0)),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['type'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            item['rating'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 16,
                          ),
                          Flexible(
                            child: Text(
                              item['location'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
