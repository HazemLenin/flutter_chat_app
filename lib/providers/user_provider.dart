import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../models/user_model.dart';
// import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  FirestoreService firestoreService = FirestoreService();
  // var uuid = const Uuid();
  // String? _uid;
  // String? _email;

  // Getters
  // String? get uid => _uid;
  // String? get email => _email;
  Stream<List<UserModel>> get users => firestoreService.getUsers();

  // Function
  Future<void> setUser(UserModel user) {
    return firestoreService.setUser(user);
  }

  Stream<List<UserModel>> filterUsersEmail(String query) => firestoreService.filterUsersEmail(query);
}