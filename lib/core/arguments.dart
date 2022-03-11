import 'package:expense_repository/expense_repository.dart';
import 'package:income_repository/income_repository.dart';

class EditScreenArguments {
  final bool isExpense;
  final Expense? expense;
  final Income? income;
  final String transactionID;

  EditScreenArguments({
    this.isExpense = true,
    this.expense,
    this.income,
    this.transactionID = '',
  });
}