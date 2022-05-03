import 'package:expense_repository/expense_repository.dart';
import 'package:extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nil/nil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../constants/constants.dart';
import '../core/core.dart';
import 'widgets.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({
    Key? key,
    required this.expenses,
    this.isSearch = false,
    this.expenseTotal = 0.0,
    this.last7DaysMaxExpense = 0.0,
    this.last7DaysExpenses = const {},
  }) : super(key: key);

  final List<Expense> expenses;
  final bool isSearch;
  final double expenseTotal;
  final Map<DateTime, double> last7DaysExpenses;
  final double last7DaysMaxExpense;

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final List<int> _scrollToPositions = [];
  late final ItemScrollController _itemScrollController;
  late final ValueNotifier<bool> _showFab;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();
    _showFab = ValueNotifier(true);
    populateScrollable();
  }

  @override
  void didUpdateWidget(covariant ExpenseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    populateScrollable();
  }

  @override
  void dispose() {
    _showFab.dispose();
    super.dispose();
  }

  void scrollToIndex(int index) => _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );

  void populateScrollable() {
    _scrollToPositions.clear();
    _scrollToPositions.add(0);
    for (int index = 0; index < widget.expenses.length; index++) {
      if (index != 0) {
        final DateTime _currentDate = widget.expenses[index - 1].date;
        final DateTime _nextDate = widget.expenses[index].date;
        if (!DateOnlyCompare(_currentDate).isSameDate(_nextDate)) {
          if (!_scrollToPositions.contains(index)) {
            _scrollToPositions.add(index);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              _showFab.value = true;
            } else if (notification.direction == ScrollDirection.reverse) {
              _showFab.value = false;
            }
            return true;
          },
          child: ScrollablePositionedList.separated(
            itemScrollController: _itemScrollController,
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 20.0,
            ),
            itemCount: widget.expenses.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                if (widget.isSearch) {
                  return nil;
                } else {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: const RadialGradient(
                        center: Alignment.topLeft,
                        radius: 7,
                        colors: [
                          Colors.redAccent,
                          Colors.orangeAccent,
                          Colors.yellowAccent,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (widget.last7DaysMaxExpense > 0.0)
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                graphView,
                                arguments: GraphScreenArguments(
                                  last7DaysTransactions: widget.last7DaysExpenses,
                                  last7DaysMaxTransaction: widget.last7DaysMaxExpense,
                                ),
                              ),
                              icon: const Icon(Icons.auto_graph),
                              color: Colors.white,
                            ),
                          ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Expense Total',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Text(
                                  '\u{20B9} ${widget.expenseTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              final Expense _expense = widget.expenses[index - 1];
              return TransactionListItem(
                transactionTitle: _expense.title,
                transactionDate: _expense.date,
                transactionAmount: _expense.expense,
                transactionCategory: _expense.category,
                transactionCategoryColor: _expense.categoryColor,
                onPressed: () => widget.isSearch
                    ? Navigator.pushReplacementNamed(
                        context,
                        edit,
                        arguments: EditScreenArguments(
                          expense: _expense,
                        ),
                      )
                    : Navigator.pushNamed(
                        context,
                        edit,
                        arguments: EditScreenArguments(
                          expense: _expense,
                        ),
                      ),
              );
            },
            separatorBuilder: (context, index) {
              if (widget.isSearch) {
                return nil;
              } else {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateSeperator(dateTime: widget.expenses[index].date),
                        DateDropDown(
                          scrollToPositions: _scrollToPositions,
                          transactionDates: widget.expenses
                              .map((expense) => expense.date)
                              .toList(),
                          onChanged: (value) {
                            for (int index in _scrollToPositions) {
                              if (value ==
                                  dateTimeToString(
                                      widget.expenses[index].date)) {
                                scrollToIndex(index + 1);
                                break;
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  /*final DateTime _currentDate = widget.expenses[index - 1].date;
                  final DateTime _nextDate = widget.expenses[index].date;
                  if (DateOnlyCompare(_currentDate).isSameDate(_nextDate)) {
                    return const SizedBox.shrink();
                  } else {
                    if (!_scrollToPositions.contains(index)) {
                      _scrollToPositions.add(index);
                    }
                    return DateSeperator(dateTime: _nextDate);
                  }*/
                  if (_scrollToPositions.contains(index)) {
                    return DateSeperator(dateTime: widget.expenses[index].date);
                  } else {
                    return nil;
                  }
                }
              }
            },
          ),
        ),
        Positioned(
          bottom: _size.height * 0.03,
          right: _size.width * 0.05,
          child: ValueListenableBuilder<bool>(
              valueListenable: _showFab,
              builder: (context, value, child) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: value
                        ? FloatingActionButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              edit,
                              arguments: const EditScreenArguments(),
                            ),
                            child: const Icon(Icons.add),
                          )
                        : nil);
              }),
        ),
        Positioned(
          bottom: _size.height * 0.05,
          right: _size.width * 0.4,
          left: _size.width * 0.4,
          child: ValueListenableBuilder<bool>(
            valueListenable: _showFab,
            builder: (context, value, child) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: value
                  ? nil
                  : FloatingActionButton(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      elevation: 0.0,
                      onPressed: () {
                        scrollToIndex(0);
                        _showFab.value = true;
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.angleDoubleUp,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
