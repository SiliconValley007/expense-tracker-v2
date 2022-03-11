part of 'expese_search_cubit.dart';

class ExpenseSearchState extends Equatable {
  const ExpenseSearchState({
    this.expense = const [],
    this.isLoading = false,
  });

  final List<Expense> expense;
  final bool isLoading;

  @override
  List<Object> get props => [expense, isLoading];

  ExpenseSearchState copyWith({
    List<Expense>? expense,
    bool? isLoading,
  }) =>
      ExpenseSearchState(
        expense: expense ?? this.expense,
        isLoading: isLoading ?? this.isLoading,
      );
}
