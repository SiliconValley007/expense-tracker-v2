import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensions/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/models.dart';

class ExpenseRepository {
  ExpenseRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    //_collectionReference = FirebaseFirestore.instance
    //.collection('todo-${_firebaseAuth.currentUser?.uid}');
    _collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid ?? '')
        .collection('expenses');
  }

  final FirebaseAuth _firebaseAuth;
  late final CollectionReference _collectionReference;

  Future<DocumentReference> addExpense({required Expense expense}) async {
    return await _collectionReference.add(expense.toMap());
  }

  Stream<List<Expense>> getExpenses() {
    return _collectionReference
        .orderBy('date', descending: true)
        .snapshots()
        .map((expenses) => expenses.docs
            .map((expense) => Expense.fromMap(
                expense.data() as Map<String, dynamic>,
                id: expense.id))
            .toList());
  }

  Future<List<Expense>> getSearchedExpenses({String query = ''}) async {
    final result = await _collectionReference
        .where("searchParams", arrayContains: query)
        .get();
    return result.docs
        .map((expense) => Expense.fromMap(
            expense.data() as Map<String, dynamic>,
            id: expense.id))
        .toList();
  }

  Future<List<Expense>> getExpenseByCategory({required String category}) async {
    final result =
        await _collectionReference.where('category', isEqualTo: category).get();
    return result.docs
        .map((expense) => Expense.fromMap(
            expense.data() as Map<String, dynamic>,
            id: expense.id))
        .toList();
  }

  Stream<List<double>> getExpenseTotal() {
    return _collectionReference
        .snapshots()
        .map((expenses) => expenses.docs.map((expense) {
              final Expense _expense = Expense.fromMap(
                expense.data() as Map<String, dynamic>,
                id: expense.id,
              );
              return _expense.expense;
            }).toList());
  }

  Future<List<Map<DateTime, List<Expense>>>> getLast7DaysExpenses() async {
    final List<Map<DateTime, List<Expense>>> _expenseMap = [];

    //the current date without the time
    final DateTime now = OnlyDate(DateTime.now()).onlyDate();

    //the subtracted date without the time
    final DateTime previous =
        OnlyDate(now.subtract(const Duration(days: 6))).onlyDate();

    final int startDate = now.millisecondsSinceEpoch;
    final int previousDate = previous.millisecondsSinceEpoch;

    final result = await _collectionReference
        .where('date', isGreaterThanOrEqualTo: previousDate)
        .where('date', isLessThanOrEqualTo: startDate)
        .get();
    List<Expense> _expenses = result.docs
        .map((expense) => Expense.fromMap(
            expense.data() as Map<String, dynamic>,
            id: expense.id))
        .toList();
    for (int i = 0; i < 7; i++) {
      final List<Expense> _tempExpenses = [];
      for (Expense expense in _expenses) {
        if (DateOnlyCompare(expense.date)
            .isSameDate(now.subtract(Duration(days: i)))) {
          if (!_tempExpenses.contains(expense)) {
            _tempExpenses.add(expense);
          }
        }
      }
      _expenseMap.add({now.subtract(Duration(days: i)): _tempExpenses});
    }
    return _expenseMap;
  }

  Future<List<Map<String, double>>> getExpenseTotalByCategory(
      {required String category}) async {
    final result =
        await _collectionReference.where('category', isEqualTo: category).get();
    return result.docs
        .map((expense) => {
              category: Expense.fromMap(expense.data() as Map<String, dynamic>,
                      id: expense.id)
                  .expense
            })
        .toList();
  }

  Future<void> updateExpenses(
      {required Expense expense, required String expenseId}) async {
    return await _collectionReference.doc(expenseId).update(expense.toMap());
  }

  Future<void> deleteExpensesByCategory({required String categoryName}) async {
    _collectionReference
        .where('category', isEqualTo: categoryName)
        .get()
        .then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        await _collectionReference.doc(doc.id).delete();
      }
    });
  }

  Future<void> deleteExpense({required String expenseId}) async {
    return await _collectionReference.doc(expenseId).delete();
  }
}
