import 'package:flutter/material.dart';
import 'package:ras/models/kuliner.dart';
import 'package:ras/services/api_service.dart';
import 'detail_restoran.dart';
import 'discover_page.dart';

class SemuaRestoranPage extends StatefulWidget {
  const SemuaRestoranPage({super.key});

  @override
  State<SemuaRestoranPage> createState() => _SemuaRestoranPageState();
}

class _SemuaRestoranPageState extends State<SemuaRestoranPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Kuliner> _semuaRestoran = [];
  List<Kuliner> _filteredRestoran = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestoran();
    _searchController.addListener(_filterRestoran);
  }

  Future<void> _fetchRestoran() async {
    try {
      final data = await ApiService().getAllKuliner();
      setState(() {
        _semuaRestoran = data.map((e) => Kuliner.fromJson(e)).toList();
        _filteredRestoran = _semuaRestoran;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error memuat restoran: $e');
    }
  }

  void _filterRestoran() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRestoran =
          _semuaRestoran
              .where((r) => r.nama.toLowerCase().contains(query))
              .toList();
    });
  }

  void _navigateToTab(int index) {
    if (index == 2 || index == 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fitur ini belum tersedia')));
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DiscoverPage(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restoran',
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari restoran...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 239, 239, 239),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          _filteredRestoran.isEmpty
                              ? Center(
                                child: Text(
                                  'Tidak ada restoran ditemukan.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )
                              : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 408 / 333,
                                    ),
                                itemCount: _filteredRestoran.length,
                                itemBuilder: (context, index) {
                                  final restoran = _filteredRestoran[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => DetailRestoranPage(
                                                kuliner: restoran,
                                                semuaRestoran: _semuaRestoran,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(8),
                                                ),
                                            child: Image.network(
                                              restoran.image,
                                              height: 253,
                                              width: 408,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => const Icon(
                                                    Icons.broken_image,
                                                  ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 19,
                                              vertical: 14,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        restoran.nama,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.location_on,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              restoran.lokasi,
                                                              style: const TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      restoran.rating
                                                          .toStringAsFixed(1),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
      ),
      bottomNavigationBar: DiscoverNavBar(
        currentIndex: 0,
        onTabTapped: _navigateToTab,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur scan QR belum tersedia')),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
