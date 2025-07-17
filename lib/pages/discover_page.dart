import 'package:flutter/material.dart';
import 'beranda.dart';
import 'favorite.dart';
import 'profil.dart';
import 'peta.dart';

class DiscoverPage extends StatefulWidget {
  final int initialIndex;
  const DiscoverPage({super.key, this.initialIndex = 0});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late int _currentIndex;

  final List<Widget> _pages = [
    BerandaPage(), // 0: Beranda
    PetaPage(), // 1: Peta
    SizedBox(), // 2: Scan (handled by FAB)
    FavoritePage(), // 3: Favorit
    ProfilePage(), // 4: Profil
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (index == 2) return; // FAB handled separately
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur peta belum tersedia')),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  void _onFabTapped() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur scan QR belum tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: DiscoverNavBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabTapped,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class DiscoverNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const DiscoverNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    Color selected = Colors.white;
    Color unselected = Colors.white70;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color(0xFF61A9F9),
      child: SizedBox(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(
              icon: Icons.home,
              label: 'Beranda',
              index: 0,
              selected: currentIndex == 0,
              onTap: () => onTabTapped(0),
              selectedColor: selected,
              unselectedColor: unselected,
            ),
            _buildNavItem(
              icon: Icons.map,
              label: 'Peta',
              index: 1,
              selected: currentIndex == 1,
              onTap: () => onTabTapped(1),
              selectedColor: selected,
              unselectedColor: unselected,
            ),
            const SizedBox(width: 50), // Space for FAB
            _buildNavItem(
              icon: Icons.favorite_border,
              label: 'Favorit',
              index: 3,
              selected: currentIndex == 3,
              onTap: () => onTabTapped(3),
              selectedColor: selected,
              unselectedColor: unselected,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: 'Profil',
              index: 4,
              selected: currentIndex == 4,
              onTap: () => onTabTapped(4),
              selectedColor: selected,
              unselectedColor: unselected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool selected,
    required VoidCallback onTap,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: selected ? selectedColor : unselectedColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? selectedColor : unselectedColor,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
