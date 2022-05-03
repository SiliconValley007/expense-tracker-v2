import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/constants.dart';
import '../../../core/core.dart';
import '../../../widgets/widgets.dart';
import '../../screens.dart';

class IncomeListScreen extends StatelessWidget {
  const IncomeListScreen({Key? key, required this.onPressed}) : super(key: key);

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
        title: const Text('Your Incomes'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              search,
              arguments: SearchPreference.income,
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<IncomeCubit, IncomeState>(
          buildWhen: (previous, current) => previous.income != current.income,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (state.income.isEmpty) {
                return Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'No Incomes',
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
                            ..onTap = () => Navigator.pushNamed(context, edit,
                                arguments:
                                    EditScreenArguments(isExpense: false)),
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
                return IncomeList(
                  incomes: state.income,
                  incomeTotal: state.incomeTotal,
                  last7DaysIncomes: state.last7DaysIncomes,
                  last7DaysMaxIncome: state.last7DaysMaxIncome,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
