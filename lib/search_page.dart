import 'package:flutter/material.dart';
import 'components.dart'; // Mengambil kInputFillColor

class SearchPage extends StatefulWidget {
  final String? initialQuery;
  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0, // Mengurangi jarak antara tombol back dan search bar
        title: Container(
          height: 45,
          margin: const EdgeInsets.only(right: 20), // Margin kanan agar tidak mepet
          decoration: BoxDecoration(
            color: kInputFillColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: widget.initialQuery == null, // Otomatis keyboard muncul jika bukan dari kategori
            decoration: const InputDecoration(
              hintText: "Cari layanan atau pekerja...",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              // Di sini nanti logika pencarian backend
              setState(() {});
            },
          ),
        ),
      ),
      body: _searchController.text.isNotEmpty
          ? _buildSearchResults()
          : _buildRecentSearches(),
    );
  }

  // Tampilan jika sedang mencari (Mock Data)
  Widget _buildSearchResults() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 3, // Mock 3 hasil
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
          ),
          title: const Text("Lala Jola", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Asisten Rumah Tangga • Rp 100rb/hari"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: () {
            // Nanti arahkan ke ProfilePage pekerja
          },
        );
      },
    );
  }

  // Tampilan jika belum mengetik (Pencarian Terakhir)
  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pencarian Terakhir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            children: [
              _buildSearchChip("Asisten Rumah Tangga"),
              _buildSearchChip("Guru Les"),
              _buildSearchChip("Tukang Ledeng"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return ActionChip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      onPressed: () {
        setState(() {
          _searchController.text = label;
        });
      },
    );
  }
}