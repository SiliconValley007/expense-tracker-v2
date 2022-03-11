import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:income_repository/income_repository.dart';
import 'package:final_year_project_v2/core/core.dart';
import 'package:nil/nil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:extensions/extensions.dart';

class IncomeList extends StatefulWidget {
  const IncomeList({
    Key? key,
    required this.incomes,
    this.isSearch = false,
    this.incomeTotal = 0.0,
    this.last7DaysMaxIncome = 0.0,
    this.last7DaysIncomes = const {},
  }) : super(key: key);

  final List<Income> incomes;
  final bool isSearch;
  final double incomeTotal;
  final double last7DaysMaxIncome;
  final Map<DateTime, double> last7DaysIncomes;

  @override
  State<IncomeList> createState() => _IncomeListState();
}

class _IncomeListState extends State<IncomeList> {
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
  void didUpdateWidget(covariant IncomeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    populateScrollable();
  }

  void scrollToIndex(int index) => _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );

  void populateScrollable() {
    _scrollToPositions.clear();
    _scrollToPositions.add(0);
    for (int index = 0; index < widget.incomes.length; index++) {
      if (index != 0) {
        final DateTime _currentDate = widget.incomes[index - 1].date;
        final DateTime _nextDate = widget.incomes[index].date;
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
            itemCount: widget.incomes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                if (widget.isSearch) {
                  return nil;
                } else {
                  return Stack(
                    children: [
                      FlipCardChart(
                        front: TransactionsPieChart(
                          last7DaysTransactions: widget.last7DaysIncomes,
                        ),
                        back: TransactionsBarChart(
                          last7DaysTransactions: widget.last7DaysIncomes,
                          maxTransactionAmount: widget.last7DaysMaxIncome,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                            'Total: ${widget.incomeTotal.toStringAsFixed(2)}'),
                      )
                    ],
                  );
                }
              }
              final Income _income = widget.incomes[index - 1];
              return TransactionListItem(
                transactionTitle: _income.title,
                transactionDate: _income.date,
                transactionAmount: _income.income,
                transactionCategory: _income.category,
                transactionCategoryColor: _income.categoryColor,
                onPressed: () => widget.isSearch
                    ? Navigator.pushReplacementNamed(
                        context,
                        edit,
                        arguments: EditScreenArguments(
                          isExpense: false,
                          income: _income,
                        ),
                      )
                    : Navigator.pushNamed(
                        context,
                        edit,
                        arguments: EditScreenArguments(
                          isExpense: false,
                          income: _income,
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
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateSeperator(dateTime: widget.incomes[index].date),
                        DateDropDown(
                          scrollToPositions: _scrollToPositions,
                          transactionDates: widget.incomes
                              .map((income) => income.date)
                              .toList(),
                          onChanged: (value) {
                            for (int index in _scrollToPositions) {
                              if (value ==
                                  dateTimeToString(
                                      widget.incomes[index].date)) {
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
                  /*final DateTime _currentDate = widget.incomes[index - 1].date;
                final DateTime _nextDate = widget.incomes[index].date;
                if (DateOnlyCompare(_currentDate).isSameDate(_nextDate)) {
                  return nil;
                } else {
                  return DateSeperator(dateTime: _nextDate);
                }*/
                  if (_scrollToPositions.contains(index)) {
                    return DateSeperator(dateTime: widget.incomes[index].date);
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
            builder: (context, value, child) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: value
                    ? FloatingActionButton(
                        key: const ValueKey('FAB'),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          edit,
                          arguments: EditScreenArguments(isExpense: false),
                        ),
                        child: const Icon(Icons.add),
                      )
                    : nil),
          ),
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
                      key: const ValueKey('FAB'),
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
