import 'package:category_repository/category_repository.dart';
import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

class ExpenseSearchList extends StatefulWidget {
  const ExpenseSearchList({Key? key}) : super(key: key);

  @override
  State<ExpenseSearchList> createState() => _ExpenseSearchListState();
}

class _ExpenseSearchListState extends State<ExpenseSearchList> {
  late final TextEditingController _searchController;
  late final ValueNotifier<bool> _isSearchEmpty;

  late final ValueNotifier<Category> _categoryFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _isSearchEmpty = ValueNotifier<bool>(true);
    _categoryFilter = ValueNotifier<Category>(Category.empty);
    _searchController.addListener(() => _searchController.text.isEmpty
        ? _isSearchEmpty.value = true
        : _isSearchEmpty.value = false);
    _categoryFilter.addListener(() => _categoryFilter.value.isEmpty
        ? _isSearchEmpty.value = true
        : _isSearchEmpty.value = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _isSearchEmpty.dispose();
    _categoryFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseSearchCubit _expenseSearchCubit =
        context.read<ExpenseSearchCubit>();
    final ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _expenseSearchCubit.clearSearch();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
          foregroundColor: theme.primaryColor,
          leading: IconButton(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              bottom: 8.0,
            ),
            // maybePop used here because normal pop does not trigger willpop scope
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: ValueListenableBuilder<Category>(
            valueListenable: _categoryFilter,
            builder: (context, value, child) => Row(
              children: [
                if (value.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(value.color),
                    ),
                    child: Text(
                      value.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    enabled: value.isEmpty,
                    onChanged: (query) =>
                        _expenseSearchCubit.onSearchChanged(query: query),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search your expenses...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: _isSearchEmpty,
              builder: (context, value, child) => value
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _categoryFilter.value = Category.empty;
                      },
                      icon: const Icon(Icons.close),
                    ),
            )
          ],
          bottom: PreferredSize(
            child: ValueListenableBuilder<Category>(
              valueListenable: _categoryFilter,
              builder: (context, value, child) => value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BlocBuilder<CategoryCubit, CategoryState>(
                        buildWhen: (previous, current) =>
                            previous.categories != current.categories,
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (state.categories.isEmpty) {
                              return nil;
                            } else {
                              return SearchCategoryList(
                                categories: state.categories,
                                categoryFilter: _categoryFilter,
                                searchPreference: SearchPreference.expense,
                              );
                            }
                          }
                        },
                      ),
                    )
                  : nil,
            ),
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.045),
          ),
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: _isSearchEmpty,
          builder: (context, value, child) {
            if (value) {
              return BlocBuilder<ExpenseCubit, ExpenseState>(
                buildWhen: (previous, current) =>
                    previous.expense != current.expense,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (state.expense.isEmpty) {
                      return Center(
                        child: Text(
                          'No Expenses.\nAdd some...',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    } else {
                      return ExpenseList(
                        expenses: state.expense,
                        isSearch: true,
                      );
                    }
                  }
                },
              );
            } else {
              return BlocBuilder<ExpenseSearchCubit, ExpenseSearchState>(
                buildWhen: (previous, current) =>
                    previous.expense != current.expense,
                builder: (context, state) => state.expense.isEmpty
                    ? const Center(
                        child: Text('No Results found'),
                      )
                    : ExpenseList(
                        expenses: state.expense,
                        isSearch: true,
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}
