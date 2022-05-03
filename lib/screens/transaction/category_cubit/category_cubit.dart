import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({CategoryRepository? categoryRepository})
      : _categoryRepository = categoryRepository ?? CategoryRepository(),
        super(const CategoryState(isLoading: true)) {
    _categoryStreamSubscription = _categoryRepository.getCategories().listen(
          (categories) => emit(
            state.copyWith(
              categories: categories,
              isLoading: false,
            ),
          ),
        );
  }

  final CategoryRepository _categoryRepository;
  late final StreamSubscription _categoryStreamSubscription;

  @override
  Future<void> close() {
    _categoryStreamSubscription.cancel();
    return super.close();
  }

  void addCategory({required Category category}) async =>
      await _categoryRepository.addCategory(category: category);

  void updateCategory({
    required Category category,
    required String categoryId,
  }) async =>
      await _categoryRepository.updateCategory(
        category: category,
        categoryId: categoryId,
      );

  void deleteCategory({required String categoryId}) async =>
      await _categoryRepository.deleteCategory(categoryId: categoryId);
}
