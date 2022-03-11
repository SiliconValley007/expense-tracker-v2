import 'package:final_year_project_v2/screens/transaction/transaction.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extensions/extensions.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    Key? key,
    required this.categoryColor,
    required this.categoryName,
    required this.categoryBudget,
    required this.onPressed,
  }) : super(key: key);

  final int categoryColor;
  final String categoryName;
  final double categoryBudget;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(categoryColor),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  MoneyFormat(categoryBudget).toMoney(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<IncomeCubit, IncomeState>(
                  buildWhen: (previous, current) =>
                      categoryName ==
                      ((current.incomeCategoryTotal.keys.isEmpty)
                          ? ''
                          : current.incomeCategoryTotal.keys.first),
                  builder: (context, state) =>
                      state.incomeCategoryTotal[categoryName] == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              state.incomeCategoryTotal[categoryName]
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                ),
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  buildWhen: (previous, current) =>
                      categoryName == current.expenseCategoryTotal.keys.first,
                  builder: (context, state) =>
                      state.expenseCategoryTotal[categoryName] == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              state.expenseCategoryTotal[categoryName]
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                ),
              ],
            ),
            BlocBuilder<ExpenseCubit, ExpenseState>(
              buildWhen: (previous, current) =>
                  categoryName == current.expenseCategoryTotal.keys.first,
              builder: (context, state) =>
                  state.expenseCategoryTotal[categoryName] == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ProgressLine(
                          color: Color(categoryColor),
                          percentage:
                              ((state.expenseCategoryTotal[categoryName]! /
                                      100) *
                                  categoryBudget),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
