import 'package:category_repository/category_repository.dart';
import 'package:flutter/rendering.dart';
import 'package:nil/nil.dart';
import '../../../constants/constants.dart';
import '../../screens.dart';
import '../../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key, this.onPressed}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const CategoryListScreen(),
      );

  final VoidCallback? onPressed;

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final List<String> _categoryNames = [];
  final List<Color> _categoryColors = [];

  late final ScrollController _controller;

  late final TextEditingController _categoryNameController;
  late final TextEditingController _categoryBudgetController;

  late final ValueNotifier<Color> _selectedColor;
  late final ValueNotifier<bool> _isFabVisible;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _categoryNameController = TextEditingController();
    _categoryBudgetController = TextEditingController();
    _selectedColor = ValueNotifier<Color>(Colors.transparent);
    _isFabVisible = ValueNotifier<bool>(true);
    _controller.addListener(() {
      _isFabVisible.value =
          _controller.position.userScrollDirection == ScrollDirection.forward;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _categoryNameController.dispose();
    _categoryBudgetController.dispose();
    _selectedColor.dispose();
    _isFabVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: DrawerMenuItem(onPressed: widget.onPressed ?? () {}),
        backgroundColor: _theme.scaffoldBackgroundColor,
        foregroundColor: _theme.primaryColor,
        elevation: 0.0,
        title: BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (previous, current) =>
              previous.categories.length != current.categories.length,
          builder: (context, state) => Text(
            'Your Categories (${state.categories.length}/${categoryColors.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (previous, current) =>
              previous.categories != current.categories,
          builder: (context, state) => _CategoryList(
            categories: state.categories,
            categoryColor: _categoryColors,
            categoryNames: _categoryNames,
            controller: _controller,
            categoryNameController: _categoryNameController,
            categoryBudgetController: _categoryBudgetController,
            selectedColor: _selectedColor,
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isFabVisible,
        builder: (context, value, child) => value
            ? FloatingActionButton(
                onPressed: () => showCategoryAddDialog(
                  context: context,
                  categoryNameController: _categoryNameController,
                  categoryBudgetController: _categoryBudgetController,
                  selectedColor: _selectedColor,
                  currentCategoryNames: _categoryNames,
                  currentCategoryColors: _categoryColors,
                ),
                child: const Icon(Icons.add),
              )
            : nil,
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    Key? key,
    required this.categories,
    required this.categoryNames,
    required this.categoryColor,
    required this.controller,
    required this.categoryNameController,
    required this.categoryBudgetController,
    required this.selectedColor,
  }) : super(key: key);

  final List<Category> categories;
  final List<String> categoryNames;
  final List<Color> categoryColor;
  final ScrollController controller;
  final TextEditingController categoryNameController;
  final TextEditingController categoryBudgetController;
  final ValueNotifier<Color> selectedColor;

  @override
  Widget build(BuildContext context) {
    categoryNames.clear();
    categoryColor.clear();
    if (categories.isEmpty) {
      return const Center(
        child: Text('No Categories'),
      );
    } else {
      return ListView.separated(
        controller: controller,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final Category _category = categories[index];
          updateCurrentCategory(_category);
          context
              .read<ExpenseCubit>()
              .getExpenseTotalByCategory(categoryName: _category.name);
          return CategoryListItem(
            categoryName: _category.name,
            categoryColor: _category.color,
            categoryBudget: _category.budget,
            onPressedUpdate: () => showCategoryAddDialog(
              categoryObject: _category,
              context: context,
              categoryNameController: categoryNameController,
              categoryBudgetController: categoryBudgetController,
              selectedColor: selectedColor,
              currentCategoryNames: categoryNames,
              currentCategoryColors: categoryColor,
            ),
            onPressedDelete: _category == Category.empty
                ? () {}
                : () => showCategoryDeleteDialog(
                      context: context,
                      categoryId: _category.id,
                      categoryName: _category.name,
                    ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 20.0,
        ),
      );
    }
  }

  void updateCurrentCategory(Category category) {
    if (!categoryColor.contains(Color(category.color))) {
      categoryColor.add(Color(category.color));
    }
    if (!categoryNames.contains(category.name)) {
      categoryNames.add(category.name);
    }
  }
}
