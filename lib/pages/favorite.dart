import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ras/models/wisata.dart';
import 'package:ras/pages/detail_wisata.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _selectedCategory = 0;
  List<Wisata> _favoritWisata = [];
  bool _isLoading = true;

  final List<String> categories = [
    'Semua Kategori',
    'Destinasi Wisata',
    'Restoran',
    'Penginapan',
  ];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteWisata();
  }

  Future<void> _fetchFavoriteWisata() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || userId <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User belum login.")));
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://xplore-app-328588022038.asia-southeast2.run.app/api/favoritwisata/$userId',
        ),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print('[DEBUG] Raw favorit data: $data');

        final wisataList =
            data.map((e) {
              final wisataJson = e['wisata'];
              final id = wisataJson['id_wisata'] ?? 0;
              final nama = wisataJson['nama_wisata'] ?? 'Nama Tidak Tersedia';
              final List<String> fotoList =
                  (wisataJson['foto_wisata'] != null &&
                          wisataJson['foto_wisata'] is List)
                      ? List<String>.from(wisataJson['foto_wisata'])
                      : [];

              final String rawFoto = fotoList.isEmpty ? '' : fotoList.first;

              final image =
                  rawFoto.isEmpty
                      ? 'https://via.placeholder.com/150'
                      : (rawFoto.startsWith('http')
                          ? Uri.encodeFull(rawFoto)
                          : Uri.encodeFull(
                            'https://storage.googleapis.com/xplores/$rawFoto',
                          ));

              print('[📷 LOG] ID: $id | Nama: $nama');
              print('[📷 LOG] Jumlah Foto: ${fotoList.length}');
              print('[📷 LOG] URL Gambar: $image');

              return Wisata(
                id: id,
                foto: fotoList,
                nama: nama,
                lokasi: e['lokasi_wisata'] ?? 'Lokasi Tidak Tersedia',
                deskripsi: e['deskripsi'] ?? '',
                rating: (e['rating'] ?? 0).toDouble(),
              );
            }).toList();

        setState(() {
          _favoritWisata = wisataList;
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data favorit');
      }
    } catch (e) {
      print('[ERROR] Fetch favorit: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFromFavorite(Wisata wisata) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    final key = 'favorite_${wisata.id}';
    await prefs.setBool(key, false);

    final url = Uri.parse(
      'https://xplore-app-328588022038.asia-southeast2.run.app/api/user/$userId/wisata/favorites/${wisata.id}',
    );

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          _favoritWisata.removeWhere((item) => item.id == wisata.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil dihapus dari favorit')),
        );
      } else {
        print('[ERROR DELETE] ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal hapus dari favorit')),
        );
      }
    } catch (e) {
      print('[ERROR] Saat menghapus favorit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter kategori
    List<Wisata> filteredItems =
        _selectedCategory == 0
            ? _favoritWisata
            : _favoritWisata.where((item) {
              switch (_selectedCategory) {
                case 1:
                  return true; // saat ini semua dianggap "Destinasi Wisata"
                case 2:
                case 3:
                  return false; // belum ada restoran/penginapan di favorit
                default:
                  return false;
              }
            }).toList();

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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Kategori
                  Container(
                    color: const Color(0xFF61A9F9),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
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
                                  color:
                                      selected
                                          ? Colors.blue
                                          : Colors.blue.shade100,
                                ),
                              ),
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  // List favorit
                  Expanded(
                    child:
                        filteredItems.isEmpty
                            ? const Center(
                              child: Text("Belum ada destinasi favorit."),
                            )
                            : ListView.separated(
                              padding: const EdgeInsets.all(12),
                              itemCount: filteredItems.length,
                              separatorBuilder:
                                  (_, __) => const Divider(height: 18),
                              itemBuilder: (context, index) {
                                final wisata = filteredItems[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(8),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        wisata.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            ),
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Destinasi Wisata',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          wisata.nama,
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
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          Text(
                                            wisata.rating.toStringAsFixed(1),
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
                                              wisata.lokasi,
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
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                        size: 28,
                                      ),
                                      onPressed:
                                          () => _removeFromFavorite(wisata),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => DetailWisataPage(
                                                wisata: wisata,
                                                semuaDestinasi: _favoritWisata,
                                              ),
                                        ),
                                      );
                                    },
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
