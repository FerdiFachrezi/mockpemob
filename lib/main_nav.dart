import 'package:flutter/material.dart';
import 'components.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'orders_page.dart'; 
import 'search_page.dart'; // Pastikan SearchPage diimport
import 'main.dart'; // Import untuk akses MyApp.isClient

class MainNav extends StatefulWidget {
  // GlobalKey untuk akses navigasi dari halaman lain
  static final GlobalKey<MainNavState> navKey = GlobalKey<MainNavState>();

  const MainNav({super.key});

  @override
  State<MainNav> createState() => MainNavState();
}

class MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  // List halaman dan item navigasi yang akan diisi sesuai peran
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  void _initializeNavigation() {
    // Cek peran User
    bool isClient = MyApp.isClient;

    if (isClient) {
      // --- KLIEN: 4 Menu (Home, Search, Orders, Profile) ---
      _pages = [
        const HomePage(),
        const SearchPage(), // Halaman Pencarian
        const OrdersPage(),
        const ProfilePage(),
      ];

      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 28),
          activeIcon: Icon(Icons.home, size: 28),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 28),
          // Search biasanya tidak punya varian filled standard, jadi gunakan bold/warna
          activeIcon: Icon(Icons.search, size: 28, weight: 700), 
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined, size: 28),
          activeIcon: Icon(Icons.description, size: 28),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 28),
          activeIcon: Icon(Icons.person, size: 28),
          label: 'Profile',
        ),
      ];
    } else {
      // --- PEKERJA: 3 Menu (Home, Orders, Profile) ---
      // Search Dihilangkan
      _pages = [
        const HomePage(),
        const OrdersPage(),
        const ProfilePage(),
      ];

      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 28),
          activeIcon: Icon(Icons.home, size: 28),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined, size: 28),
          activeIcon: Icon(Icons.description, size: 28),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 28),
          activeIcon: Icon(Icons.person, size: 28),
          label: 'Profile',
        ),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk pindah tab secara programatis (dari tombol lain)
  void jumpToTab(int index) {
    // LOGIKA PENYESUAIAN INDEX UNTUK PEKERJA
    // Jika Pekerja, urutan index berubah karena 'Search' hilang.
    // Klien: 0=Home, 1=Search, 2=Orders, 3=Profile
    // Pekerja: 0=Home, 1=Orders, 2=Profile
    
    if (!MyApp.isClient) {
      // Jika kode lama meminta pindah ke Orders (index 2 pada Klien),
      // kita arahkan ke index 1 pada Pekerja.
      if (index == 2) {
        index = 1; 
      } 
      // Jika meminta pindah ke Profile (index 3 pada Klien),
      // kita arahkan ke index 2 pada Pekerja.
      else if (index == 3) {
        index = 2;
      }
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: MainNav.navKey,
      body: _pages[_selectedIndex], // Menampilkan halaman sesuai index
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: false, // Label sembunyi jika tidak dipilih (opsional)
        showSelectedLabels: true,
        items: _navItems, // Item navigasi dinamis
      ),
    );
  }
}