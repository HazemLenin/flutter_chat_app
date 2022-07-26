import 'package:chat_app/models/message_model.dart';
import 'package:uuid/uuid.dart';
import '../services/firestore_services.dart';

class MessageProvider {
  FirestoreService firestoreService = FirestoreService();
  Uuid uuid = const Uuid();
  Stream<List<Message>> getMessages({ required List<String> uids}) => firestoreService.getMessages(uids);
  
  Future<void> sendMessage(Message message) {
    message.id ??= uuid.v1();
    return firestoreService.sendMessage(message);
  }
}