import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AppUser(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
    );
  }
}
