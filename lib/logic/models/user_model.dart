// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    required this.uid,
  });
  final String name;
  final String email;
  final String uid;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserModel.fromFirebaseUser(User fbUser) {
    return UserModel(
      name: fbUser.displayName ?? '',
      email: fbUser.email ?? '',
      uid: fbUser.uid,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'uid': uid,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'UserModel(name: $name, email: $email, uid: $uid)';
}
