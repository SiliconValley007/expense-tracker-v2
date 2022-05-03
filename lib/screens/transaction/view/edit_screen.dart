import 'dart:ui';

import 'package:category_repository/category_repository.dart';
import 'package:expense_repository/expense_repository.dart';
import '../../../constants/constants.dart';
import '../../../core/arguments.dart';
import '../../screens.dart';
import '../../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_repository/income_repository.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.arguments}) : super(key: key);

  final EditScreenArguments arguments;

  static Route route({required EditScreenArguments arguments}) =>
      MaterialPageRoute<void>(
        builder: (_) => EditScreen(
          arguments: arguments,
        ),
      );

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen>
    with SingleTickerProviderStateMixin {
  Expense? get _userExpense => widget.arguments.expense;
  Income? get _userIncome => widget.arguments.income;
  bool get _isUserExpense => widget.arguments.isExpense;

  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _categoryBudgetController;

  late final AnimationController _animController;
  late final Animation<double> _rotationAnimation;
  late final Animation<Color?> _colorAnimation;

  late final ValueNotifier<bool> _isExpense;
  late final ValueNotifier<Color> _selectedColor;
  late final ValueNotifier<String> _currentTransactionCategory;
  late final ValueNotifier<int> _currentTransactionCategoryColor;

  final List<String> _currentCategoryNames = [];
  final List<Color> _currentCategoryColors = [];

  DateTime _currentTransactionDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _dateController =
        TextEditingController(text: dateTimeToString(DateTime.now()));
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
    _categoryBudgetController = TextEditingController();
    _isExpense = ValueNotifier<bool>(_isUserExpense);
    _selectedColor = ValueNotifier<Color>(Colors.transparent);
    _currentTransactionCategory = ValueNotifier<String>('');
    _currentTransactionCategoryColor = ValueNotifier<int>(0);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotationAnimation = (_isUserExpense
            ? Tween<double>(begin: 0.0, end: 0.5)
            : Tween<double>(begin: 0.5, end: 0.0))
        .animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _colorAnimation = (_isUserExpense
            ? ColorTween(begin: Colors.red, end: Colors.green)
            : ColorTween(begin: Colors.green, end: Colors.red))
        .animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    if (!_isUserExpense && _userIncome != null) {
      _amountController.text = _userIncome!.income.toString();
      _titleController.text = _userIncome!.title;
      _currentTransactionDate = _userIncome!.date;
      _dateController.text = dateTimeToString(_currentTransactionDate);
      _descriptionController.text = _userIncome!.description;
    } else if (_isUserExpense && _userExpense != null) {
      _amountController.text = _userExpense!.expense.toString();
      _titleController.text = _userExpense!.title;
      _currentTransactionDate = _userExpense!.date;
      _dateController.text = dateTimeToString(_currentTransactionDate);
      _currentTransactionCategory.value = _userExpense!.category;
      _descriptionController.text = _userExpense!.description;
      _currentTransactionCategoryColor.value = _userExpense!.categoryColor;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _categoryBudgetController.dispose();
    _isExpense.dispose();
    _selectedColor.dispose();
    _currentTransactionCategory.dispose();
    _currentTransactionCategoryColor.dispose();
    _animController.dispose();
    _currentCategoryColors.clear();
    _currentCategoryNames.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final IncomeCubit _incomeCubit = context.read<IncomeCubit>();
    final ExpenseCubit _expenseCubit = context.read<ExpenseCubit>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => Navigator.of(context).pop(),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(
                            (Icons.arrow_back_sharp),
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Text(
                        (_userExpense != null) ? 'Update ' : 'Add ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isExpense,
                        builder: (context, value, child) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeOut,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            opacity: Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(animation),
                            child: child,
                          ),
                          child: value
                              ? const Text(
                                  'Expense',
                                  key: Key('Expense'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: Colors.red,
                                  ),
                                )
                              : const Text(
                                  'Income',
                                  key: Key('Income'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: Colors.green,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: (_userIncome == null && _userExpense == null)
                        ? () {
                            _isExpense.value = !_isExpense.value;
                            if (_animController.isDismissed) {
                              _animController.forward();
                            } else {
                              _animController.reverse();
                            }
                          }
                        : null,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: RotationTransition(
                        turns: _rotationAnimation,
                        child: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, child) => Icon(
                            (Icons.arrow_upward),
                            color: _colorAnimation.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _size.height * 0.03,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: _size.height * 0.05,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xffc5c4c7),
                    ),
                    child: TextField(
                      controller: _amountController,
                      textAlign: TextAlign.center,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
                      ],
                      cursorColor: Colors.grey,
                      style: const TextStyle(fontSize: 50.0),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _size.height * 0.08,
                  ),
                  CustomInputWidget(
                    controller: _titleController,
                    hintText: 'Title',
                    icon: Icons.title,
                  ),
                  SizedBox(
                    height: _size.height * 0.02,
                  ),
                  CustomInputWidget(
                    controller: _dateController,
                    hintText: 'Date',
                    readOnly: true,
                    onTap: () async {
                      DateTime _pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _currentTransactionDate,
                            firstDate: DateTime(1800),
                            lastDate: DateTime.now(),
                          ) ??
                          _currentTransactionDate;
                      _currentTransactionDate = _pickedDate;
                      _dateController.text =
                          dateTimeToString(_currentTransactionDate);
                    },
                    icon: Icons.calendar_today_rounded,
                  ),
                  SizedBox(
                    height: _size.height * 0.02,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isExpense,
                    builder: (context, value, child) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) => SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                      child: value
                          ? Column(
                              key: const ValueKey('Add expense category'),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Choose a Category',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => showCategoryAddDialog(
                                        context: context,
                                        categoryNameController:
                                            _categoryController,
                                        categoryBudgetController:
                                            _categoryBudgetController,
                                        selectedColor: _selectedColor,
                                        currentCategoryNames:
                                            _currentCategoryNames,
                                        currentCategoryColors:
                                            _currentCategoryColors,
                                      ),
                                      child: const Icon(Icons.add),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                BlocBuilder<CategoryCubit, CategoryState>(
                                  buildWhen: (previous, current) =>
                                      previous.categories != current.categories,
                                  builder: (context, state) {
                                    if (state.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (state.categories.isEmpty) {
                                        return const Center(
                                          child: Text('No Categories'),
                                        );
                                      } else {
                                        return _CategoryList(
                                          categories: state.categories,
                                          currentTransactionCategory:
                                              _currentTransactionCategory,
                                          currentTransactionCategoryColor:
                                              _currentTransactionCategoryColor,
                                          categoryNames: _currentCategoryNames,
                                          categoryColors:
                                              _currentCategoryColors,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('remove category'),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: _size.height * 0.04,
                  ),
                  CustomInputWidget(
                    controller: _descriptionController,
                    hintText: 'Description',
                    icon: Icons.description,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (_userIncome != null || _userExpense != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (_userIncome != null)
                            ? Text(
                                dateTimeToString(_userIncome!.createdAt),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Text(
                                dateTimeToString(_userExpense!.createdAt),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        IconButton(
                          onPressed: () async {
                            await showTransactionDeleteDialog(
                              context: context,
                              isExpense: _userIncome == null,
                              onConfirmPressed: () {
                                (_userIncome != null)
                                    ? _incomeCubit.deleteIncome(
                                        incomeId: _userIncome!.id)
                                    : _expenseCubit.deleteExpense(
                                        expenseId: _userExpense!.id);
                                Navigator.of(context).pop();
                              },
                            );
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Container(
              height: _size.height * 0.13,
              width: _size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
                child: Stack(
                  children: [
                    const CircleDecoration(
                      bottom: -20.0,
                      left: -30,
                    ),
                    const CircleDecoration(
                      top: -50.0,
                      right: 30,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  saveORupdate(_expenseCubit, _incomeCubit);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0,
                                    vertical: 15.0,
                                  ),
                                ),
                                child: Text(
                                  (_userExpense != null || _userIncome != null)
                                      ? _isExpense.value
                                          ? "Update Expense"
                                          : "Update Income"
                                      : _isExpense.value
                                          ? "Save Expense"
                                          : "Save Income",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveORupdate(
    ExpenseCubit _expenseCubit,
    IncomeCubit _incomeCubit,
  ) {
    if (_amountController.text.isEmpty || _titleController.text.isEmpty) {
      showSnackBar(context, 'Amount and title cannot be empty');
    } else {
      if (_userExpense == null && _userIncome == null) {
        if (_isExpense.value) {
          _expenseCubit.addExpense(
            expense: Expense(
              title: _titleController.text,
              description: _descriptionController.text,
              expense: double.parse(_amountController.text),
              date: _currentTransactionDate,
              createdAt: DateTime.now(),
              category: _currentTransactionCategory.value,
              categoryColor: _currentTransactionCategoryColor.value,
              searchParams: setSearchParam(_titleController.text),
            ),
          );
        } else {
          _incomeCubit.addIncome(
            income: Income(
              title: _titleController.text,
              description: _descriptionController.text,
              income: double.parse(_amountController.text),
              date: _currentTransactionDate,
              createdAt: DateTime.now(),
              searchParams: setSearchParam(_titleController.text),
            ),
          );
        }
      } else {
        if (_userExpense != null && _isUserExpense) {
          _expenseCubit.updateExpense(
            expense: Expense(
              title: _titleController.text,
              description: _descriptionController.text,
              expense: double.parse(_amountController.text),
              date: _currentTransactionDate,
              createdAt: _userExpense!.createdAt,
              category: _currentTransactionCategory.value,
              categoryColor: _currentTransactionCategoryColor.value,
              searchParams: setSearchParam(_titleController.text),
            ),
            expenseId: _userExpense!.id,
          );
        } else if (_userIncome != null && !_isUserExpense) {
          _incomeCubit.updateIncome(
            income: Income(
              title: _titleController.text,
              description: _descriptionController.text,
              income: double.parse(_amountController.text),
              date: _currentTransactionDate,
              createdAt: _userIncome!.createdAt,
              searchParams: setSearchParam(_titleController.text),
            ),
            incomeId: _userIncome!.id,
          );
        }
      }
    }
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    Key? key,
    required this.categories,
    required this.currentTransactionCategory,
    required this.currentTransactionCategoryColor,
    required this.categoryNames,
    required this.categoryColors,
  }) : super(key: key);

  final List<Category> categories;
  final ValueNotifier<String> currentTransactionCategory;
  final ValueNotifier<int> currentTransactionCategoryColor;
  final List<String> categoryNames;
  final List<Color> categoryColors;

  @override
  Widget build(BuildContext context) {
    categoryNames.clear();
    categoryColors.clear();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: ValueListenableBuilder(
        valueListenable: currentTransactionCategory,
        builder: (context, value, child) => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final Category _category = categories[index];
            updateCurrentCategoryList(_category);
            return GestureDetector(
              onTap: () {
                if (currentTransactionCategory.value == _category.name) {
                  currentTransactionCategory.value = '';
                  currentTransactionCategoryColor.value = 0;
                } else {
                  currentTransactionCategory.value = _category.name;
                  currentTransactionCategoryColor.value = _category.color;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(_category.color),
                    border: value == _category.name
                        ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                        : null),
                child: Text(
                  _category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            width: 10.0,
          ),
        ),
      ),
    );
  }

  void updateCurrentCategoryList(Category category) {
    if (!categoryNames.contains(category.name)) {
      categoryNames.add(category.name);
    }
    if (!categoryColors.contains(Color(category.color))) {
      categoryColors.add(Color(category.color));
    }
  }
}
