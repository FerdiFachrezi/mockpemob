import 'package:flutter/material.dart';
import 'components.dart';
import 'main_nav.dart'; 

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // State untuk Input
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _addressController = TextEditingController(text: "Jalan Dr. T. Mansur No.9");
  final TextEditingController _noteController = TextEditingController();
  
  // Controller untuk input layanan manual (jika pilih Lainnya)
  final TextEditingController _customServiceController = TextEditingController();

  // Opsi Layanan (Bisa disesuaikan dengan Kategori Pekerja nantinya)
  final List<String> _serviceOptions = [
    "Pembersihan Harian (Sap & Pel)",
    "Cuci & Setrika Pakaian",
    "Memasak Harian",
    "Jaga Anak / Balita",
    "Lainnya" // Opsi untuk memicu input manual
  ];

  late String _selectedService;

  @override
  void initState() {
    super.initState();
    _selectedService = _serviceOptions[0]; // Default pilih yang pertama
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Form Pemesanan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. INFO PEKERJA (Tanpa Tarif) ---
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset('assets/images/avatar_placeholder.png', width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 15),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lala Jola", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text("Asisten Rumah Tangga", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- 2. JADWAL ---
                  const SectionLabel(label: "Jadwal Pengerjaan"),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(color: kInputFillColor, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                                const SizedBox(width: 10),
                                Text(
                                  _selectedDate == null 
                                    ? "Pilih Tanggal" 
                                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                  style: TextStyle(color: _selectedDate == null ? Colors.grey : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickTime(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(color: kInputFillColor, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                                const SizedBox(width: 10),
                                Text(
                                  _selectedTime == null 
                                    ? "Jam Mulai" 
                                    : _selectedTime!.format(context),
                                  style: TextStyle(color: _selectedTime == null ? Colors.grey : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- 3. LOKASI ---
                  const SectionLabel(label: "Lokasi Pengerjaan"),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kInputFillColor,
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- 4. PILIHAN LAYANAN (Update Logic) ---
                  const SectionLabel(label: "Pilih Layanan"),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(color: kInputFillColor, borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedService,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _serviceOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) {
                          setState(() => _selectedService = val!);
                        },
                      ),
                    ),
                  ),
                  
                  // LOGIC: Jika pilih "Lainnya", munculkan input text baru
                  if (_selectedService == "Lainnya") ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _customServiceController,
                      decoration: InputDecoration(
                        hintText: "Tuliskan jenis layanan yang dibutuhkan...",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        filled: true,
                        fillColor: kInputFillColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                    ),
                  ],

                  const SizedBox(height: 25),
                  
                  // --- 5. CATATAN ---
                  const SectionLabel(label: "Catatan Tambahan (Opsional)"),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Contoh: Tolong bawa alat sendiri, rumah pagar hitam...",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: kInputFillColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 6. BOTTOM BAR ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validasi sederhana sebelum submit
                  if (_selectedDate == null || _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mohon lengkapi jadwal pengerjaan")));
                    return;
                  }
                  _showSuccessDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Buat Pesanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- LOGIC HELPERS ---

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 24),
              
              const Text(
                "Pemesanan Berhasil!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              const Text(
                "Permintaan Anda telah dikirim ke pekerja. Silakan tunggu konfirmasi selanjutnya.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const MainNav(initialIndex: 2)
                      ), 
                      (route) => false
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Lihat Status Pesanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const MainNav(initialIndex: 0)), 
                    (route) => false
                  );
                },
                child: const Text("Kembali ke Beranda", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
    );
  }
}