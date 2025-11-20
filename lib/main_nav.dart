import 'package:flutter/material.dart';
import 'components.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const HomePage(),                       // Index 0: Beranda
    const Center(child: Text("Pencarian")), // Index 1: Placeholder
    const Center(child: Text("Pesanan")),   // Index 2: Placeholder
    const ProfilePage(),                    // Index 3: Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Menampilkan halaman sesuai index
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Agar semua icon muncul labelnya
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor, // Warna icon aktif (Biru Tua)
        unselectedItemColor: Colors.grey, // Warna icon tidak aktif
        onTap: _onItemTapped,
        showUnselectedLabels: false, // Sesuai desain, label non-aktif biasanya hidden atau kecil
        showSelectedLabels: false,   // Di gambar tidak ada label teks, hanya icon
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28),
            activeIcon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet_outlined, size: 28),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28),
            activeIcon: Icon(Icons.person, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}