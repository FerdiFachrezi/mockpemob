import 'package:flutter/material.dart';
import 'components.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'orders_page.dart'; // <--- IMPORT HALAMAN BARU

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text("Pencarian")),
    const OrdersPage(), // <--- GANTI PLACEHOLDER DENGAN HALAMAN PESANAN
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        showSelectedLabels: false,
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
          // Ikon Pesanan (Dokumen/List)
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined, size: 28), // Menggunakan icon dokumen
            activeIcon: Icon(Icons.description, size: 28),
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