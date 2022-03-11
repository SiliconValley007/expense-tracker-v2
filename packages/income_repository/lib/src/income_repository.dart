import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:extensions/extensions.dart';

import 'models/models.dart';

class IncomeRepository {
  IncomeRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    //_collectionReference = FirebaseFirestore.instance
    //.collection('todo-${_firebaseAuth.currentUser?.uid}');
    _collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid ?? '')
        .collection('incomes');
  }

  final FirebaseAuth _firebaseAuth;
  late final CollectionReference _collectionReference;

  Future<DocumentReference> addIncome({required Income income}) async {
    return await _collectionReference.add(income.toMap());
  }

  Stream<List<Income>> getIncome() {
    return _collectionReference
        .orderBy('date', descending: true)
        .snapshots()
        .map((incomes) => incomes.docs
            .map((income) => Income.fromMap(
                income.data() as Map<String, dynamic>,
                id: income.id))
            .toList());
  }

  Future<List<Map<DateTime, List<Income>>>> getLast7DaysIncomes() async {
    final List<Map<DateTime, List<Income>>> _incomeMap = [];

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
    List<Income> _incomes = result.docs
        .map((income) => Income.fromMap(
            income.data() as Map<String, dynamic>,
            id: income.id))
        .toList();
    for (int i = 0; i < 7; i++) {
      final List<Income> _tempIncomes = [];
      for (Income income in _incomes) {
        if (DateOnlyCompare(income.date)
            .isSameDate(now.subtract(Duration(days: i)))) {
          if (!_tempIncomes.contains(income)) {
            _tempIncomes.add(income);
          }
        }
      }
      _incomeMap.add({now.subtract(Duration(days: i)): _tempIncomes});
    }
    return _incomeMap;
  }

  Future<List<Income>> getSearchedIncomes({String query = ''}) async {
    final QuerySnapshot result = await _collectionReference
        .where("searchParams", arrayContains: query)
        .get();
    return result.docs
        .map((income) => Income.fromMap(income.data() as Map<String, dynamic>,
            id: income.id))
        .toList();
  }

  Future<List<Income>> getIncomeByCategory({required String category}) async {
    var result = await _collectionReference
        .where("category", isEqualTo: category)
        .get();
    return result.docs
        .map((income) => Income.fromMap(income.data() as Map<String, dynamic>,
            id: income.id))
        .toList();
  }

  Stream<List<double>> getIncomeTotal() {
    return _collectionReference
        .snapshots()
        .map((incomes) => incomes.docs.map((income) {
              final Income _income = Income.fromMap(
                income.data() as Map<String, dynamic>,
                id: income.id,
              );
              return _income.income;
            }).toList());
  }

  Future<List<Map<String, double>>> getIncomeTotalByCategory(
      {required String category}) async {
    final result =
        await _collectionReference.where('category', isEqualTo: category).get();
    return result.docs
        .map((income) => {
              category: Income.fromMap(income.data() as Map<String, dynamic>,
                      id: income.id)
                  .income
            })
        .toList();
  }

  Future<void> updateIncome(
      {required Income income, required String incomeId}) async {
    return await _collectionReference.doc(incomeId).update(income.toMap());
  }

  Future<void> deleteIncome({required String incomeId}) async {
    return await _collectionReference.doc(incomeId).delete();
  }
}
