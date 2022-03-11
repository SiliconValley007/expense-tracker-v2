import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("users");

  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String get currentUserId => _firebaseAuth.currentUser?.uid ?? '';

  Future<UserProfile> get currentUser async =>
      await getCurrentUserProfile(uid: currentUserId);

  Future<UserProfile> getCurrentUserProfile({required String uid}) async {
    final userData = await _collectionReference.doc(uid).get();
    return UserProfile.fromMap(userData.data() as Map<String, dynamic>,
        id: uid);
  }

  Stream<UserProfile> getCurrentUserProfileStream({required String uid}) {
    return _collectionReference.doc(uid).snapshots().map((user) =>
        UserProfile.fromMap(user.data() as Map<String, dynamic>, id: user.id));
  }

  Future<void> addUserProfile({required UserProfile userProfile}) async {
    return await _collectionReference
        .doc(userProfile.id)
        .set(userProfile.toMap());
  }

  Future<void> updateUserProfile({required UserProfile userProfile}) async {
    await _collectionReference.doc(userProfile.id).update(userProfile.toMap());
  }

  /*Future<void> deleteUserProfile() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser != null) {
      UserCredential result = await firebaseUser.reauthenticateWithCredential(EmailAuthProvider.credential(email: email, password: firebaseUser.));
    }
    result.user.delete();
    await _collectionReference
        .doc(_firebaseAuth.currentUser?.uid ?? '')
        .delete();
    await _firebaseAuth.currentUser!.delete();
  }*/
}

extension FirebaseUsertoUserProfile on User {
  UserProfile get toUser {
    return UserProfile(
        id: uid,
        email: email ?? '',
        name: displayName ?? '',
        photo: photoURL ?? '',
        createdOn: DateFormat.yMMMMd().format(metadata.creationTime!));
  }
}
