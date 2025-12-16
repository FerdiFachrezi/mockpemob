import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String clientId;
  final String clientName;
  final String workerId;
  final String workerName;
  final String serviceCategory; // Misal: "AC Repair"
  final String status; // 'pending', 'accepted', 'rejected', 'completed'
  final String address;
  final String note;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime scheduledDate;

  OrderModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.workerId,
    required this.workerName,
    required this.serviceCategory,
    required this.status,
    required this.address,
    required this.note,
    required this.totalPrice,
    required this.createdAt,
    required this.scheduledDate,
  });

  // Konversi dari Firestore ke Dart Object
  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? 'Client',
      workerId: map['workerId'] ?? '',
      workerName: map['workerName'] ?? 'Worker',
      serviceCategory: map['serviceCategory'] ?? 'General',
      status: map['status'] ?? 'pending',
      address: map['address'] ?? '-',
      note: map['note'] ?? '-',
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      scheduledDate: (map['scheduledDate'] as Timestamp).toDate(),
    );
  }

  // Konversi dari Dart Object ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'workerId': workerId,
      'workerName': workerName,
      'serviceCategory': serviceCategory,
      'status': status,
      'address': address,
      'note': note,
      'totalPrice': totalPrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'scheduledDate': Timestamp.fromDate(scheduledDate),
    };
  }
}