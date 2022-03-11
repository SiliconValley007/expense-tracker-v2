part of 'expense_cubit.dart';

class ExpenseState extends Equatable {
  const ExpenseState({
    this.expense = const [],
    this.isLoading = false,
    this.expenseTotal = 0,
    this.last7DaysMaxExpense = 0,
    this.expenseCategoryTotal = const {},
    this.last7DaysExpenses = const {},
  });

  final List<Expense> expense;
  final double expenseTotal;
  final Map<String, double> expenseCategoryTotal;
  final Map<DateTime, double> last7DaysExpenses;
  final double last7DaysMaxExpense;
  final bool isLoading;

  @override
  List<Object> get props => [
        expense,
        isLoading,
        expenseTotal,
        last7DaysMaxExpense,
        expenseCategoryTotal,
        last7DaysExpenses
      ];

  ExpenseState copyWith({
    List<Expense>? expense,
    double? expenseTotal,
    double? last7DaysMaxExpense,
    Map<String, double>? expenseCategoryTotal,
    Map<DateTime, double>? last7DaysExpenses,
    bool? isLoading,
  }) =>
      ExpenseState(
        expense: expense ?? this.expense,
        expenseTotal: expenseTotal ?? this.expenseTotal,
        isLoading: isLoading ?? this.isLoading,
        last7DaysMaxExpense: last7DaysMaxExpense ?? this.last7DaysMaxExpense,
        expenseCategoryTotal: expenseCategoryTotal ?? this.expenseCategoryTotal,
        last7DaysExpenses: last7DaysExpenses ?? this.last7DaysExpenses,
      );
}
