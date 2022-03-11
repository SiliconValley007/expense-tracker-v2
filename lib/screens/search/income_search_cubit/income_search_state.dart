part of 'income_search_cubit.dart';

class IncomeSearchState extends Equatable {
  const IncomeSearchState({
    this.income = const [],
    this.isLoading = false,
  });

  final List<Income> income;
  final bool isLoading;

  @override
  List<Object> get props => [income, isLoading];

  IncomeSearchState copyWith({
    List<Income>? income,
    bool? isLoading,
  }) =>
      IncomeSearchState(
        income: income ?? this.income,
        isLoading: isLoading ?? this.isLoading,
      );
}
