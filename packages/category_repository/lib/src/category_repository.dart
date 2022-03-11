import 'package:category_repository/src/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryRepository {
  CategoryRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    //_collectionReference = FirebaseFirestore.instance
    //.collection('todo-${_firebaseAuth.currentUser?.uid}');
    _collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid ?? '')
        .collection('categories');
  }

  final FirebaseAuth _firebaseAuth;
  late final CollectionReference _collectionReference;

  Stream<List<Category>> getCategories() {
    return _collectionReference.snapshots().map((categories) => categories.docs
        .map((category) => Category.fromMap(
            category.data() as Map<String, dynamic>,
            id: category.id))
        .toList());
  }

  Future<DocumentReference> addCategory({required Category category}) async {
    return await _collectionReference.add(category.toMap());
  }

  Future<Category> getSingleCategoryByName(
      {required String categoryName}) async {
    return await _collectionReference.get().then(
          (categories) => categories.docs
              .map((category) => Category.fromMap(
                  category.data() as Map<String, dynamic>,
                  id: category.id))
              .where((categoryModel) => categoryModel.name == categoryName)
              .first,
        );
  }

  Future<void> updateCategory(
      {required Category category, required String categoryId}) async {
    await _collectionReference.doc(categoryId).update(category.toMap());
  }

  Future<void> deleteCategory({required String categoryId}) async {
    await _collectionReference.doc(categoryId).delete();
  }

  Future<void> deleteAllCategories() async {
    QuerySnapshot snapshot = await _collectionReference.get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await _collectionReference.doc(doc.id).delete();
    }
  }
}