import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'expense_search_state.dart';

class ExpenseSearchCubit extends Cubit<ExpenseSearchState> {
  ExpenseSearchCubit({ExpenseRepository? expenseRepository})
      : _expenseRepository = expenseRepository ?? ExpenseRepository(),
        super(const ExpenseSearchState(isLoading: true));

  final ExpenseRepository _expenseRepository;

  void onSearchChanged({required String query}) async {
    List<Expense> _expenses = await _expenseRepository.getSearchedExpenses(
        query: query.toLowerCase());
    emit(state.copyWith(
      expense: _expenses,
      isLoading: false,
    ));
  }

  void searchByCategory({required String categoryName}) async {
    List<Expense> _expenses =
        await _expenseRepository.getExpenseByCategory(category: categoryName);
    emit(state.copyWith(
      expense: _expenses,
      isLoading: false,
    ));
  }

  void clearSearch() => emit(
        state.copyWith(
          expense: const [],
          isLoading: false,
        ),
      );
}
