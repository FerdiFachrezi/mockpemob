import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Buat Pesanan Baru (Dipanggil oleh Klien di BookingPage)
  Future<void> createOrder(OrderModel order) async {
    await _firestore.collection('orders').add(order.toMap());
  }

  // 2. Ambil Daftar Pesanan (Real-time)
  Stream<List<OrderModel>> streamOrders(String uid, bool isClient) {
    // Jika Client: Ambil pesanan yang clientId == uid
    // Jika Worker: Ambil pesanan yang workerId == uid
    String fieldName = isClient ? 'clientId' : 'workerId';

    return _firestore
        .collection('orders')
        .where(fieldName, isEqualTo: uid)
        .orderBy('createdAt', descending: true) // Urutkan dari yang terbaru
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 3. Update Status (Terima / Tolak / Selesai)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }
}