import 'package:flutter/material.dart';
import 'components.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'orders_page.dart'; 
import 'search_page.dart'; // Pastikan search_page.dart ada
import 'main.dart'; 

class MainNav extends StatefulWidget {
  // GlobalKey ini PENTING agar HomePage bisa memanggil fungsi di sini
  static final GlobalKey<MainNavState> navKey = GlobalKey<MainNavState>();
  
  final int initialIndex; 

  const MainNav({super.key, this.initialIndex = 0});

  @override
  State<MainNav> createState() => MainNavState();
}

// Perhatikan: Nama class tidak pakai underscore (_) agar bisa diakses dari luar
class MainNavState extends State<MainNav> {
  late int _selectedIndex;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _initializeNavigation();
  }

  void _initializeNavigation() {
    // Cek peran User (Klien atau Pekerja)
    bool isClient = MyApp.isClient;

    if (isClient) {
      // --- NAVIGASI KLIEN (4 Tab) ---
      _pages = [
        const HomePage(),
        const SearchPage(), // Index 1: Search
        const OrdersPage(),
        const ProfilePage(),
      ];

      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Cari"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Pesanan"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ];
    } else {
      // --- NAVIGASI PEKERJA (3 Tab) ---
      _pages = [
        const HomePage(),
        const OrdersPage(),
        const ProfilePage(),
      ];

      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Pekerjaan"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- INI FUNGSI YANG HILANG SEBELUMNYA ---
  // Fungsi ini dipanggil dari HomePage untuk pindah tab secara otomatis
  void jumpToTab(int index) {
    // Penyesuaian Index jika user adalah PEKERJA (karena jumlah tab beda)
    if (!MyApp.isClient) {
      // Jika Klien minta ke Orders (idx 2), Pekerja ke Orders (idx 1)
      if (index == 2) index = 1; 
      // Jika Klien minta ke Profile (idx 3), Pekerja ke Profile (idx 2)
      else if (index == 3) index = 2;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: MainNav.navKey, // Hubungkan Key ke Scaffold
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _navItems,
      ),
    );
  }
}