import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel? contact;

  const ChatPage({Key? key, required this.contact}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messageProvider = context.read<MessageProvider>();
    final authProvider = context.read<FirebaseAuthService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact?.displayName ?? '')
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              initialData: null,
              stream: messageProvider.getMessages(uids: [authProvider.currentUser!.uid, widget.contact!.uid]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: message.senderUid == authProvider.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Text(message.text),
                          ]
                        ),
                        leading: message.senderUid == authProvider.currentUser!.uid ? null : CircleAvatar(child: Text(message.senderDisplayName[0])),
                        trailing: message.senderUid == authProvider.currentUser!.uid ? CircleAvatar(child: Text(message.senderDisplayName[0])) : null,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString(), style: const TextStyle(color: Colors.red));
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            )
          ),
          Row(
            children: [
              Expanded(
                flex: 9,
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    label: Text('message'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    messageProvider.sendMessage(Message(
                      uids: {
                        authProvider.currentUser!.uid: true,
                        widget.contact!.uid: true
                      },
                      senderUid: authProvider.currentUser!.uid,
                      senderDisplayName: authProvider.currentUser!.displayName ?? '',
                      text: messageController.text.trim(),
                      sentAt: DateTime.now().toString()
                    ));
                    messageController.clear();
                  },
                  child: const Icon(Icons.send),
                )
              ),
            ],
          )
        ],
      )
    );
  }
}