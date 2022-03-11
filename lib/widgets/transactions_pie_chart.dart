import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//DateFormat('EEEE').format(_tempDate)

class TransactionsPieChart extends StatelessWidget {
  const TransactionsPieChart({
    Key? key,
    required this.last7DaysTransactions,
  }) : super(key: key);

  final Map<DateTime, double> last7DaysTransactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      color: Colors.grey,
      child: AspectRatio(
        aspectRatio: 0.9,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    enabled: false,
                  ),
                  sections: last7DaysTransactions
                      .map(
                        (date, amount) => MapEntry(
                          date,
                          PieChartSectionData(
                            color: chartWeekDayColors[
                                DateFormat('EEEE').format(date)],
                            radius: 120.0,
                            title: '$amount',
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            titlePositionPercentageOffset: .50,
                            value: amount,
                            /*badgeWidget: Text(
                            (DateFormat('EEEE').format(date)).substring(0, 3),
                          ),
                          badgePositionPercentageOffset: .98,*/
                          ),
                        ),
                      )
                      .values
                      .toList(),
                  centerSpaceRadius: 30,
                  sectionsSpace: 0,
                  borderData: FlBorderData(
                    show: false,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                children: last7DaysTransactions.keys
                    .map(
                      (date) => Legend(
                        color: chartWeekDayColors[
                                DateFormat('EEEE').format(date)] ??
                            Colors.transparent,
                        title:
                            (DateFormat('EEEE').format(date)).substring(0, 3),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
