import 'package:category_repository/category_repository.dart';
import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

//! also implment logic for when user enters name already in database
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
    builder: (context) => AlertDialog(
      title: Text(
        'Add New Category',
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
            //! Add logic for when all the colors have been used and the user cannot select any more colors.
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
              context.read<CategoryCubit>().addCategory(
                    category: Category(
                      name: categoryNameController.text,
                      color: selectedColor.value.value,
                      budget: double.parse(categoryBudgetController.text),
                    ),
                  );
            }
            Navigator.pop(context);
          },
          child: Text(
            'Save',
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
