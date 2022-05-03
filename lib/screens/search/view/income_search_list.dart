import '../../screens.dart';
import '../../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeSearchList extends StatefulWidget {
  const IncomeSearchList({Key? key}) : super(key: key);

  @override
  State<IncomeSearchList> createState() => _IncomeSearchListState();
}

class _IncomeSearchListState extends State<IncomeSearchList> {
  late final TextEditingController _searchController;
  late final ValueNotifier<bool> _isSearchEmpty;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _isSearchEmpty = ValueNotifier<bool>(true);
    _searchController.addListener(() => _searchController.text.isEmpty
        ? _isSearchEmpty.value = true
        : _isSearchEmpty.value = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _isSearchEmpty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final IncomeSearchCubit _incomeSearchCubit =
        context.read<IncomeSearchCubit>();
    final ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _incomeSearchCubit.clearSearch();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
          foregroundColor: theme.primaryColor,
          leading: IconButton(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              bottom: 8.0,
            ),
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: TextField(
            controller: _searchController,
            onChanged: (query) =>
                _incomeSearchCubit.onSearchChanged(query: query),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search your incomes...',
              hintStyle: TextStyle(
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: _isSearchEmpty,
              builder: (context, value, child) => value
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: const Icon(Icons.close),
                    ),
            )
          ],
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: _isSearchEmpty,
          builder: (context, value, child) {
            if (value) {
              return BlocBuilder<IncomeCubit, IncomeState>(
                buildWhen: (previous, current) =>
                    previous.income != current.income,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (state.income.isEmpty) {
                      return Center(
                        child: Text(
                          'No Incomes.\nAdd some...',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    } else {
                      return IncomeList(
                        incomes: state.income,
                        isSearch: true,
                      );
                    }
                  }
                },
              );
            } else {
              return BlocBuilder<IncomeSearchCubit, IncomeSearchState>(
                buildWhen: (previous, current) =>
                    previous.income != current.income,
                builder: (context, state) => state.income.isEmpty
                    ? const Center(
                        child: Text('No results'),
                      )
                    : IncomeList(
                        incomes: state.income,
                        isSearch: true,
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}
