import 'package:category_repository/category_repository.dart';
import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

class IncomeSearchList extends StatefulWidget {
  const IncomeSearchList({Key? key}) : super(key: key);

  @override
  State<IncomeSearchList> createState() => _IncomeSearchListState();
}

class _IncomeSearchListState extends State<IncomeSearchList> {
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
    final IncomeSearchCubit _incomeSearchCubit =
        context.read<IncomeSearchCubit>();
    final ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _incomeSearchCubit.clearSearch();
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
                        _incomeSearchCubit.onSearchChanged(query: query),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search your incomes...',
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
                                searchPreference: SearchPreference.income,
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
              return BlocBuilder<IncomeCubit, IncomeState>(
                buildWhen: (previous, current) =>
                    previous.income != current.income,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (state.income.isEmpty) {
                      return Center(
                        child: Text(
                          'No Incomes.\nAdd some...',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    } else {
                      return IncomeList(
                        incomes: state.income,
                        isSearch: true,
                      );
                    }
                  }
                },
              );
            } else {
              return BlocBuilder<IncomeSearchCubit, IncomeSearchState>(
                buildWhen: (previous, current) =>
                    previous.income != current.income,
                builder: (context, state) => state.income.isEmpty
                    ? const Center(
                        child: Text('No results'),
                      )
                    : IncomeList(
                        incomes: state.income,
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
