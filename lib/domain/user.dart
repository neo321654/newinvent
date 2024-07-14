import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  late String? id;
  String? email;
  String? name;

  MyUser({this.id, this.name, this.email});

  factory MyUser.fromMap(map) {
    return MyUser(id: map['id'], email: map['email'], name: map['organization']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'organization': name};
  }

  MyUser.fromFirebase(User user) {
    id = user.uid;
  }
}
