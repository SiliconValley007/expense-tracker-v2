import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:extensions/extensions.dart';
import 'package:final_year_project_v2/screens/transaction/data_carrier/data_carrier.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit({ExpenseRepository? expenseRepository})
      : _expenseRepository = expenseRepository ?? ExpenseRepository(),
        super(const ExpenseState(isLoading: true)) {
    _expenseStreamSubscription =
        _expenseRepository.getExpenses().listen((expenses) async {
      double _expensesTotal = 0;
      for (Expense expense in expenses) {
        _expensesTotal += expense.expense;
      }
      final List<Map<DateTime, List<Expense>>> _last7DaysExpenses =
          await _expenseRepository.getLast7DaysExpenses();
      final MaxDataMap _expenseDataMap = _createDataMap(_last7DaysExpenses);
      emit(
        state.copyWith(
          expense: expenses,
          expenseTotal: _expensesTotal,
          isLoading: false,
          last7DaysExpenses: _expenseDataMap.dataMap,
          last7DaysMaxExpense: _expenseDataMap.maxValue,
        ),
      );
    });
  }

  final ExpenseRepository _expenseRepository;
  late final StreamSubscription _expenseStreamSubscription;

  @override
  Future<void> close() {
    _expenseStreamSubscription.cancel();
    return super.close();
  }

  MaxDataMap _createDataMap(
      List<Map<DateTime, List<Expense>>> last7DaysExpenses) {
    final transactions = <DateTime, double>{};
    double max = 0.0;
    for (int i = 6; i >= 0; i--) {
      final DateTime _tempDate =
          (OnlyDate(DateTime.now().subtract(Duration(days: i))).onlyDate());
      transactions[_tempDate] = 0.0;
      for (Map<DateTime, List<Expense>> expenses in last7DaysExpenses) {
        List<Expense> _tempExpenses = expenses[_tempDate] ?? [];
        for (Expense expense in _tempExpenses) {
          transactions.update(
            _tempDate,
            (value) {
              if ((value + expense.expense) > max) {
                max = value + expense.expense;
              }
              return value + expense.expense;
            },
            ifAbsent: () {
              if ((expense.expense) > max) {
                max = expense.expense;
              }
              return expense.expense;
            },
          );
        }
      }
    }
    return MaxDataMap(dataMap: transactions, maxValue: max);
  }

  void getExpenseTotalByCategory({required String categoryName}) async {
    final List<Map<String, double>> _expenses = await _expenseRepository
        .getExpenseTotalByCategory(category: categoryName);
    double temp = 0;
    for (Map<String, double> expense in _expenses) {
      temp += expense[categoryName] ?? 0;
    }
    emit(state.copyWith(expenseCategoryTotal: {categoryName: temp}));
  }

  void addExpense({required Expense expense}) async =>
      await _expenseRepository.addExpense(expense: expense);

  void updateExpense({
    required Expense expense,
    required String expenseId,
  }) async =>
      await _expenseRepository.updateExpenses(
        expense: expense,
        expenseId: expenseId,
      );

  void deleteExpense({required String expenseId}) async =>
      await _expenseRepository.deleteExpense(expenseId: expenseId);
}
