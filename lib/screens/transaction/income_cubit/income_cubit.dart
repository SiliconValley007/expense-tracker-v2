import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_year_project_v2/screens/transaction/data_carrier/data_carrier.dart';
import 'package:income_repository/income_repository.dart';
import 'package:extensions/extensions.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit({IncomeRepository? incomeRepository})
      : _incomeRepository = incomeRepository ?? IncomeRepository(),
        super(const IncomeState(isLoading: true)) {
    _incomeStreamSubscription =
        _incomeRepository.getIncome().listen((incomes) async {
      double _incomeTotal = 0;
      for (Income income in incomes) {
        _incomeTotal += income.income;
      }
      final List<Map<DateTime, List<Income>>> _last7DaysIncomes =
          await _incomeRepository.getLast7DaysIncomes();
      final MaxDataMap _incomeDataMap = _createDataMap(_last7DaysIncomes);
      emit(
        state.copyWith(
          income: incomes,
          incomeTotal: _incomeTotal,
          isLoading: false,
          last7DaysIncomes: _incomeDataMap.dataMap,
          last7DaysMaxIncome: _incomeDataMap.maxValue,
        ),
      );
    });
  }

  final IncomeRepository _incomeRepository;
  late final StreamSubscription _incomeStreamSubscription;

  @override
  Future<void> close() {
    _incomeStreamSubscription.cancel();
    return super.close();
  }

  MaxDataMap _createDataMap(
      List<Map<DateTime, List<Income>>> last7DaysIncomes) {
    final transactions = <DateTime, double>{};
    double max = 0.0;
    for (int i = 6; i >= 0; i--) {
      final DateTime _tempDate =
            (OnlyDate(DateTime.now().subtract(Duration(days: i))).onlyDate());
      transactions[_tempDate] = 0.0;
      for (Map<DateTime, List<Income>> incomes in last7DaysIncomes) {
        List<Income> _tempIncomes = incomes[_tempDate] ?? [];
        for (Income income in _tempIncomes) {
          transactions.update(
            _tempDate,
            (value) {
              if ((value + income.income) > max) {
                max = value + income.income;
              }
              return value + income.income;
            },
            ifAbsent: () {
              if ((income.income) > max) {
                max = income.income;
              }
              return income.income;
            },
          );
        }
      }
    }
    return MaxDataMap(dataMap: transactions, maxValue: max);
  }

  void getIncomeTotalByCategory({required String categoryName}) async {
    final List<Map<String, double>> _incomes = await _incomeRepository
        .getIncomeTotalByCategory(category: categoryName);
    double temp = 0;
    for (Map<String, double> income in _incomes) {
      temp += income[categoryName] ?? 0;
    }
    emit(state.copyWith(incomeCategoryTotal: {categoryName: temp}));
  }

  void addIncome({required Income income}) async =>
      await _incomeRepository.addIncome(income: income);

  void updateIncome({
    required Income income,
    required String incomeId,
  }) async =>
      await _incomeRepository.updateIncome(
        income: income,
        incomeId: incomeId,
      );

  void deleteIncome({required String incomeId}) async =>
      await _incomeRepository.deleteIncome(incomeId: incomeId);
}
