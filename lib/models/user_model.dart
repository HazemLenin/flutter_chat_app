class UserModel {
  String uid;
  String email;
  String displayName;

  UserModel({required this.uid, required this.email, required this.displayName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }
}