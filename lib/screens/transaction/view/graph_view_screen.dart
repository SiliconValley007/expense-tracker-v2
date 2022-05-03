import '../../../core/arguments.dart';
import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';

class GraphViewScreen extends StatelessWidget {
  const GraphViewScreen({
    Key? key,
    required this.graphScreenArguments,
  }) : super(key: key);

  final GraphScreenArguments graphScreenArguments;

  static Route route({required GraphScreenArguments graphScreenArguments}) =>
      MaterialPageRoute<void>(
        builder: (_) => GraphViewScreen(
          graphScreenArguments: graphScreenArguments,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _theme.scaffoldBackgroundColor,
        foregroundColor: _theme.primaryColor,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Pie Chart',
              style: TextStyle(
                color: _theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 15.0),
            TransactionsPieChart(
              last7DaysTransactions: graphScreenArguments.last7DaysTransactions,
            ),
            const SizedBox(height: 25.0),
            Text(
              'Bar Chart',
              style: TextStyle(
                color: _theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 15.0),
            TransactionsBarChart(
              last7DaysTransactions: graphScreenArguments.last7DaysTransactions,
              maxTransactionAmount:
                  graphScreenArguments.last7DaysMaxTransaction,
            ),
          ],
        ),
      ),
    );
  }
}
