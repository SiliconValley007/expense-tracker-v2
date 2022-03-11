import 'dart:convert';

import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final String description;
  final double expense;
  final DateTime date;
  final DateTime createdAt;
  final String category;
  final int categoryColor;
  final List<String> searchParams;

  const Expense({
    this.id = '',
    required this.title,
    this.description = '',
    required this.expense,
    required this.date,
    required this.createdAt,
    this.category = '',
    this.categoryColor = 0,
    required this.searchParams,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      expense,
      date,
      createdAt,
      category,
      categoryColor,
      searchParams,
    ];
  }

  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? expense,
    DateTime? date,
    DateTime? createdAt,
    String? category,
    int? categoryColor,
    List<String>? searchParams,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      expense: expense ?? this.expense,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      categoryColor: categoryColor ?? this.categoryColor,
      searchParams: searchParams ?? this.searchParams,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'expense': expense,
      'date': DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
      'createdAt': DateTime(createdAt.year, createdAt.month, createdAt.day).millisecondsSinceEpoch,
      'category': category,
      'categoryColor': categoryColor,
      'searchParams': searchParams,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map , {String? id}) {
    return Expense(
      id: id ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      expense: map['expense']?.toDouble() ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      category: map['category'] ?? '',
      categoryColor: map['categoryColor']?.toInt() ?? 0,
      searchParams: List<String>.from(map['searchParams']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, description: $description, expense: $expense, date: $date, createdAt: $createdAt, category: $category, categoryColor: $categoryColor, searchParams: $searchParams)';
  }
}
