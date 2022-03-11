part of 'income_cubit.dart';

class IncomeState extends Equatable {
  const IncomeState({
    this.income = const [],
    this.isLoading = false,
    this.incomeTotal = 0,
    this.last7DaysMaxIncome = 0,
    this.incomeCategoryTotal = const {},
    this.last7DaysIncomes = const {},
  });

  final List<Income> income;
  final double incomeTotal;
  final double last7DaysMaxIncome;
  final bool isLoading;
  final Map<String, double> incomeCategoryTotal;
  final Map<DateTime, double> last7DaysIncomes;

  @override
  List<Object> get props => [
        income,
        isLoading,
        incomeTotal,
        last7DaysMaxIncome,
        incomeCategoryTotal,
        last7DaysIncomes,
      ];

  IncomeState copyWith({
    List<Income>? income,
    double? incomeTotal,
    double? last7DaysMaxIncome,
    Map<String, double>? incomeCategoryTotal,
    Map<DateTime, double>? last7DaysIncomes,
    bool? isLoading,
  }) =>
      IncomeState(
        income: income ?? this.income,
        isLoading: isLoading ?? this.isLoading,
        incomeTotal: incomeTotal ?? this.incomeTotal,
        last7DaysMaxIncome: last7DaysMaxIncome ?? this.last7DaysMaxIncome,
        incomeCategoryTotal: incomeCategoryTotal ?? this.incomeCategoryTotal,
        last7DaysIncomes: last7DaysIncomes ?? this.last7DaysIncomes,
      );
}
