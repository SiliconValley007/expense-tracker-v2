import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';

class TransactionsBarChart extends StatelessWidget {
  const TransactionsBarChart({
    Key? key,
    required this.last7DaysTransactions,
    required this.maxTransactionAmount,
  }) : super(key: key);

  final Map<DateTime, double> last7DaysTransactions;
  final double maxTransactionAmount;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        color: const Color(0xff81e5cd),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: maxTransactionAmount,
              groupsSpace: MediaQuery.of(context).size.width * 0.06,
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final DateTime _date =
                        DateTime.fromMillisecondsSinceEpoch(group.x);
                    return BarTooltipItem(
                      '${DateFormat('d').format(_date)} ${(DateFormat('MMMM').format(_date)).substring(0, 3)}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: (rod.y).toString(),
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: SideTitles(showTitles: false),
                topTitles: SideTitles(showTitles: false),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  margin: 16,
                  getTitles: (value) {
                    return (DateFormat('EEEE').format(
                            DateTime.fromMillisecondsSinceEpoch(value.toInt())))
                        .substring(0, 3);
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              gridData: FlGridData(show: false),
              barGroups: last7DaysTransactions
                  .map(
                    (date, amount) => MapEntry(
                      date,
                      BarChartGroupData(
                        x: date.millisecondsSinceEpoch,
                        barRods: [
                          BarChartRodData(
                            y: amount,
                            colors: [
                              chartWeekDayColors[
                                      DateFormat('EEEE').format(date)] ??
                                  Colors.transparent
                            ],
                            width: 22,
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 0,
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              y: maxTransactionAmount,
                              show: true,
                              colors: [Colors.grey.shade300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
