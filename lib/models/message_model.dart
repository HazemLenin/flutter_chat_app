class Message {
  String? id;
  final Map<String, dynamic> uids;
  final String senderUid;
  final String senderDisplayName;
  final String text;
  final String sentAt;

  Message({this.id, required this.uids, required this.senderUid, required this.senderDisplayName, required this.text, required this.sentAt});

  factory Message.fromJson(Map<dynamic, dynamic> json) {
    return Message(
      id: json['id'],
      uids: (json['uids'] as Map<String, dynamic>),
      senderUid: json['senderUid'],
      senderDisplayName: json['senderDisplayName'],
      text: json['text'],
      sentAt: json['sentAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uids': uids,
      'senderUid': senderUid,
      'senderDisplayName': senderDisplayName,
      'text': text,
      'sentAt': sentAt,
    };
  }
  
}