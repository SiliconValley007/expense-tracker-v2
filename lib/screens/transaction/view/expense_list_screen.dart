import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({Key? key, required this.onPressed})
      : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: DrawerMenuItem(onPressed: onPressed),
        backgroundColor: _theme.scaffoldBackgroundColor,
        foregroundColor: _theme.primaryColor,
        elevation: 0.0,
        title: const Text('Your Expenses'),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(
                    context,
                    search,
                    arguments: SearchPreference.expense,
                  ),
              icon: const Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ExpenseCubit, ExpenseState>(
          buildWhen: (previous, current) => previous.expense != current.expense,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (state.expense.isEmpty) {
                return Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'No Expenses',
                      children: [
                        const TextSpan(text: '\n Add some'),
                        TextSpan(
                          text: ' + ',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(context, edit),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              } else {
                return ExpenseList(
                  expenses: state.expense,
                  expenseTotal: state.expenseTotal,
                  last7DaysExpenses: state.last7DaysExpenses,
                  last7DaysMaxExpense: state.last7DaysMaxExpense,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
