import 'package:extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/transaction/transaction.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    Key? key,
    required this.categoryColor,
    required this.categoryName,
    required this.categoryBudget,
    required this.onPressedUpdate,
    required this.onPressedDelete,
  }) : super(key: key);

  final int categoryColor;
  final String categoryName;
  final double categoryBudget;
  final VoidCallback onPressedUpdate;
  final VoidCallback onPressedDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return LayoutBuilder(builder: (_, constraints) {
      return BlocBuilder<ExpenseCubit, ExpenseState>(
        buildWhen: (previous, current) =>
            categoryName == current.expenseCategoryTotal.keys.first,
        builder: (context, state) => state.expenseCategoryTotal[categoryName] ==
                null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ExpansionTile(
                collapsedBackgroundColor: _theme.colorScheme.secondary,
                backgroundColor: _theme.colorScheme.secondary,
                textColor: _theme.primaryColor,
                collapsedTextColor: _theme.primaryColor,
                tilePadding: const EdgeInsets.all(10.0),
                childrenPadding: const EdgeInsets.all(10.0),
                expandedCrossAxisAlignment: CrossAxisAlignment.end,
                title: Text(categoryName),
                leading: Container(
                  width: constraints.maxWidth * 0.05,
                  decoration: BoxDecoration(
                    color: Color(categoryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                trailing: (categoryBudget -
                            (state.expenseCategoryTotal[categoryName] ?? 0))
                        .isNegative
                    ? const Text(
                        'Overspent',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      )
                    : Text(
                        '${MoneyFormat(categoryBudget - (state.expenseCategoryTotal[categoryName] ?? 0)).toMoney()} left',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total budget: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        MoneyFormat(categoryBudget).toMoney(),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total expense: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        MoneyFormat(
                                state.expenseCategoryTotal[categoryName] ?? 0)
                            .toMoney(),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Budget left: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        (categoryBudget -
                                    (state.expenseCategoryTotal[categoryName] ??
                                        0))
                                .isNegative
                            ? '${MoneyFormat((categoryBudget - (state.expenseCategoryTotal[categoryName] ?? 0)).abs()).toMoney()} overspent'
                            : MoneyFormat(categoryBudget -
                                    (state.expenseCategoryTotal[categoryName] ??
                                        0))
                                .toMoney(),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  if ((categoryBudget -
                          (state.expenseCategoryTotal[categoryName] ?? 0))
                      .isNegative)
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Budget overflow!!You have overspent.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onPressedUpdate,
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: onPressedDelete,
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      );
    });
  }
}
