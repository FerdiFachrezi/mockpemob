import 'package:flutter/material.dart';
import 'components.dart';
import 'worker_profile_page.dart'; 
import 'main_nav.dart'; // [PENTING] Import MainNav untuk navigasi ke Home

class SearchPage extends StatefulWidget {
  final String? initialQuery;
  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

  final List<String> _recentSearches = [
    "Asisten Rumah Tangga",
    "Tukang Ledeng",
    "Guru Les Matematika"
  ];

  final List<String> _popularTags = [
    "Bersih-bersih",
    "Supir",
    "Tukang Cat",
    "Service AC",
    "Masak",
    "Laundry"
  ];

  final List<Map<String, dynamic>> _searchResults = [
    {
      "name": "Siti Aminah",
      "role": "Asisten Rumah Tangga",
      "rating": "5.0",
      "location": "Medan Tembung",
      "image": "assets/images/avatar_placeholder.png"
    },
    {
      "name": "Budi Santoso",
      "role": "Tukang Ledeng & Pipa",
      "rating": "4.9",
      "location": "Medan Kota",
      "image": "assets/images/avatar_placeholder.png"
    },
    {
      "name": "Rina Nose",
      "role": "Guru Les Privat",
      "rating": "4.8",
      "location": "Medan Baru",
      "image": "assets/images/avatar_placeholder.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER PENCARIAN ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  // [PERBAIKAN NAVIGASI BACK]
                  InkWell(
                    onTap: () {
                      // Paksa navigasi kembali ke MainNav (Home) index 0
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const MainNav(initialIndex: 0)
                        ), 
                        (route) => false
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: kInputFillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        autofocus: widget.initialQuery == null,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Cari layanan atau pekerja...",
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onChanged: (val) {
                          setState(() {}); 
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. KONTEN BODY ---
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildInitialState() 
                  : _buildResultList(),  
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pencarian Terakhir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                GestureDetector(
                  onTap: () => setState(() => _recentSearches.clear()),
                  child: const Text("Hapus Semua", style: TextStyle(color: Colors.red, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(_recentSearches[index], style: const TextStyle(color: Colors.black87)),
                  trailing: const Icon(Icons.north_west, size: 16, color: Colors.grey),
                  onTap: () {
                    _searchController.text = _recentSearches[index];
                    setState(() {});
                  },
                );
              },
            ),
            const SizedBox(height: 25),
          ],

          const Text("Pencarian Populer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _popularTags.map((tag) => _buildTagChip(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return _buildWorkerCard(item);
      },
    );
  }
  
  Widget _buildTagChip(String label) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13)),
      ),
    );
  }

  Widget _buildWorkerCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkerProfilePage()));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(data['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 14),
                          const SizedBox(width: 4),
                          Text(data['rating'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(data['role'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(data['location'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey))
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
  }
}