import 'dart:convert';

import 'package:equatable/equatable.dart';

class Income extends Equatable {
  final String id;
  final String title;
  final String description;
  final double income;
  final DateTime date;
  final DateTime createdAt;
  final List<String> searchParams;

  const Income({
    this.id = '',
    required this.title,
    this.description = '',
    required this.income,
    required this.date,
    required this.createdAt,
    required this.searchParams,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      income,
      date,
      createdAt,
      searchParams,
    ];
  }

  Income copyWith({
    String? id,
    String? title,
    String? description,
    double? income,
    DateTime? date,
    DateTime? createdAt,
    List<String>? searchParams,
  }) {
    return Income(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      income: income ?? this.income,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      searchParams: searchParams ?? this.searchParams,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'income': income,
      'date': DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
      'createdAt': DateTime(createdAt.year, createdAt.month, createdAt.day).millisecondsSinceEpoch,
      'searchParams': searchParams,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map , {String? id}) {
    return Income(
      id: id ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      income: map['income']?.toDouble() ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      searchParams: List<String>.from(map['searchParams']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Income.fromJson(String source) => Income.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Income(id: $id, title: $title, description: $description, income: $income, date: $date, createdAt: $createdAt, searchParams: $searchParams)';
  }
}
