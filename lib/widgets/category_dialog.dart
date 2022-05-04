import 'package:category_repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../constants/constants.dart';
import '../screens/screens.dart';

Future showCategoryDeleteDialog({
  required BuildContext context,
  required String categoryId,
  required String categoryName,
}) =>
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Category',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete this category?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'This will delete all expenses related to this category!!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<CategoryCubit>()
                  .deleteCategory(categoryId: categoryId);
              context
                  .read<ExpenseCubit>()
                  .deleteExpenseByCategoryName(categoryName: categoryName);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

Future showCategoryAddDialog({
  required BuildContext context,
  required TextEditingController categoryNameController,
  required TextEditingController categoryBudgetController,
  required ValueNotifier<Color> selectedColor,
  required List<String> currentCategoryNames,
  required List<Color> currentCategoryColors,
  Category categoryObject = Category.empty,
}) {
  if (categoryObject != Category.empty) {
    categoryNameController.text = categoryObject.name;
    categoryBudgetController.text = categoryObject.budget.toString();
    selectedColor.value = Color(categoryObject.color);
  }
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        categoryObject == Category.empty
            ? 'Add New Category'
            : 'Update Category',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryNameController,
              autofocus: true,
              maxLength: 15,
              cursorColor: Colors.grey,
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).primaryColor,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp('[a-zA-Z ]'),
                )
              ],
              decoration: InputDecoration(
                /*prefixIcon: Icon(
                    icon,
                    color: Theme.of(context).iconTheme.color,
                  ),*/
                border: InputBorder.none,
                hintText: 'Name',
                hintStyle: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: categoryBudgetController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
              ],
              cursorColor: Colors.grey,
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).primaryColor,
              ),
              decoration: InputDecoration(
                /*prefixIcon: Icon(
                    icon,
                    color: Theme.of(context).iconTheme.color,
                  ),*/
                border: InputBorder.none,
                hintText: 'Budget amount',
                hintStyle: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoryColors.length,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder<Color>(
                    valueListenable: selectedColor,
                    builder: (context, value, child) {
                      return currentCategoryColors
                              .contains(categoryColors[index])
                          ? nil
                          : GestureDetector(
                              onTap: () {
                                if (selectedColor.value ==
                                    categoryColors[index]) {
                                  selectedColor.value = Colors.transparent;
                                } else {
                                  selectedColor.value = categoryColors[index];
                                }
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.1,
                                width: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                  color: categoryColors[index],
                                  shape: BoxShape.circle,
                                  border: categoryColors[index] ==
                                          selectedColor.value
                                      ? null
                                      : Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 1,
                                        ),
                                ),
                                child: categoryColors[index] ==
                                        selectedColor.value
                                    ? Icon(
                                        Icons.done,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : null,
                              ),
                            );
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    currentCategoryColors.contains(categoryColors[index])
                        ? nil
                        : const SizedBox(
                            width: 5.0,
                          ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.red.withOpacity(0.8),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (categoryObject != Category.empty) {
              context.read<CategoryCubit>().updateCategory(
                    categoryId: categoryObject.id,
                    category: Category(
                      name: categoryNameController.text,
                      color: selectedColor.value.value,
                      budget: double.parse(categoryBudgetController.text),
                    ),
                  );
            } else {
              if (categoryNameController.text.isEmpty ||
                  selectedColor.value.value == 0 ||
                  categoryBudgetController.text.isEmpty) {
                showSnackBar(context, 'Please fill in all details');
              } else {
                context.read<CategoryCubit>().addCategory(
                      category: Category(
                        name: categoryNameController.text,
                        color: selectedColor.value.value,
                        budget: double.parse(categoryBudgetController.text),
                      ),
                    );
              }
            }
            Navigator.pop(context);
          },
          child: Text(
            categoryObject == Category.empty ? 'Save' : 'Update',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    ),
  ).then((_) {
    categoryNameController.clear();
    categoryBudgetController.clear();
    selectedColor.value = Colors.transparent;
  });
}
