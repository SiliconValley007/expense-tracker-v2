import 'dart:convert';

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final int color;
  final double budget;

  const Category({
    this.id = '',
    required this.name,
    required this.color,
    required this.budget,
  });

  @override
  List<Object> get props => [id, name, color, budget];

  static const empty = Category(
    name: '',
    color: 0,
    budget: 0,
  );

  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  Category copyWith({
    String? id,
    String? name,
    int? color,
    double? budget,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      budget: budget ?? this.budget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'budget': budget,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      color: map['color']?.toInt() ?? 0,
      budget: map['budget']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $name, color: $color, budget: $budget)';
  }
}
