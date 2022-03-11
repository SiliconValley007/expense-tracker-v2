import 'package:category_repository/category_repository.dart';
import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCategoryList extends StatelessWidget {
  const SearchCategoryList({
    Key? key,
    required this.categories,
    required this.categoryFilter,
    required this.searchPreference,
  }) : super(key: key);

  final List<Category> categories;
  final ValueNotifier<Category> categoryFilter;
  final SearchPreference searchPreference;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final Category _category = categories[index];
          return GestureDetector(
            onTap: () {
              categoryFilter.value = _category;
              searchPreference == SearchPreference.expense
                  ? context
                      .read<ExpenseSearchCubit>()
                      .searchByCategory(categoryName: _category.name)
                  : context
                      .read<IncomeSearchCubit>()
                      .searchByCategory(categoryName: _category.name);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(_category.color),
              ),
              child: Text(
                _category.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 10.0,
        ),
      ),
    );
  }
}
