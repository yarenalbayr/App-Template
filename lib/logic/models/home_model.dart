import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class HomeModel {
  HomeModel({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
