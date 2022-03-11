import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:income_repository/income_repository.dart';

part 'income_search_state.dart';

class IncomeSearchCubit extends Cubit<IncomeSearchState> {
  IncomeSearchCubit({IncomeRepository? incomeRepository})
      : _incomeRepository = incomeRepository ?? IncomeRepository(),
        super(const IncomeSearchState(isLoading: true));

  final IncomeRepository _incomeRepository;

  void onSearchChanged({required String query}) async {
    List<Income> _todos =
        await _incomeRepository.getSearchedIncomes(query: query.toLowerCase());
    emit(state.copyWith(
      income: _todos,
      isLoading: false,
    ));
  }

  void searchByCategory({required String categoryName}) async {
    List<Income> _incomes =
        await _incomeRepository.getIncomeByCategory(category: categoryName);
    emit(state.copyWith(
      income: _incomes,
      isLoading: false,
    ));
  }

  void clearSearch() => emit(
        state.copyWith(
          income: const [],
          isLoading: false,
        ),
      );
}
