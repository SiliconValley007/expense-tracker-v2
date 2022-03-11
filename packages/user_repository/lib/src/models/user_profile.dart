import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String email;
  final String id;
  final String name;
  final String photo;
  final String createdOn;

  const UserProfile({
    this.email = '',
    this.id = '',
    this.name = '',
    this.photo = '',
    this.createdOn = '',
  });

  static const empty = UserProfile();

  bool get isEmpty => this == UserProfile.empty;
  bool get isNotEmpty => this != UserProfile.empty;

  @override
  List<Object> get props => [email, id, name, photo, createdOn];

  UserProfile copyWith({
    String? email,
    String? id,
    String? name,
    String? photo,
    String? createdOn,
  }) {
    return UserProfile(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photo': photo,
      'createdOn': createdOn,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return UserProfile(
      email: map['email'] ?? '',
      id: id,
      name: map['name'] ?? '',
      photo: map['photo'] ?? '',
      createdOn: map['createdOn'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(email: $email, id: $id, name: $name, photo: $photo, createdOn: $createdOn)';
  }
}
