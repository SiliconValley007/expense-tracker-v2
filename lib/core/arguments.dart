import 'package:expense_repository/expense_repository.dart';
import 'package:income_repository/income_repository.dart';

class EditScreenArguments {
  final bool isExpense;
  final Expense? expense;
  final Income? income;
  final String transactionID;

  const EditScreenArguments({
    this.isExpense = true,
    this.expense,
    this.income,
    this.transactionID = '',
  });
}

class GraphScreenArguments {
  final Map<DateTime, double> last7DaysTransactions;
  final double last7DaysMaxTransaction;

  const GraphScreenArguments({
    required this.last7DaysTransactions,
    required this.last7DaysMaxTransaction,
  });
}
