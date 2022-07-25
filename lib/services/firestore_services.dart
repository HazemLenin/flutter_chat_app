import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // List all users
  Stream<List<UserModel>> getUsers() {
    return _db
    .collection('user')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJSON(doc.data())).toList());
  }

  // Filter users for search
  Stream<List<UserModel>> filterUsersEmail(String query) {
    if(query.isEmpty) { // return all users if query is empty
      return _db
      .collection('user')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJSON(doc.data())).toList());
    } else {
      return _db
      .collection('user')
      .where('email', isGreaterThanOrEqualTo: query, isLessThan: query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJSON(doc.data())).toList());
    }
  }

  // Create new user or update if exists
  Future<void> setUser(UserModel user) {
    SetOptions options = SetOptions(merge: true);

    return _db
    .collection('user')
    .doc(user.uid)
    .set(user.toMap(), options);
  }

  Future<void> deleteUser(UserModel user) {
    return _db
    .collection('user')
    .doc(user.uid)
    .delete();
  }
}