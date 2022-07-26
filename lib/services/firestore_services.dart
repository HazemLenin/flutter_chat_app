import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users

  // List all Users
  Stream<List<UserModel>> getUsers() {
    return _db
    .collection('user')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }

  // Filter Users for search
  Stream<List<UserModel>> filterUsersEmail(String query) {
    if(query.isEmpty) { // return all users if query is empty
      return _db
      .collection('user')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
    } else {
      return _db
      .collection('user')
      .where('email', isGreaterThanOrEqualTo: query, isLessThan: query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
    }
  }

  // Create new User or update if exists
  Future<void> setUser(UserModel user) {
    SetOptions options = SetOptions(merge: true);

    return _db
    .collection('user')
    .doc(user.uid)
    .set(user.toMap(), options);
  }

  // Delete User
  Future<void> deleteUser(UserModel user) {
    return _db
    .collection('user')
    .doc(user.uid)
    .delete();
  }


  // Chats

  // List messages
  Stream<List<Message>> getMessages(List<String> uids) {
    return _db
    .collection('message')
    .orderBy('sentAt')
    .where('uids.${uids[0]}', isEqualTo: true)
    .where('uids.${uids[1]}', isEqualTo: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Future<void> sendMessage(Message message) {
    SetOptions options = SetOptions(merge: true);

    return _db
    .collection('message')
    .doc(message.id)
    .set(message.toMap(), options);
  }
}