import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataSource {
  final FirebaseFirestore firestore;

  FirebaseDataSource(this.firestore);

  // Backup data
  Future<void> backupData({
    required String userId,
    required List<Map<String, dynamic>> categories,
    required List<Map<String, dynamic>> expenses,
    required List<Map<String, dynamic>> accounts,
    required Map<String, dynamic>? savings,
  }) async {
    final docRef = firestore.collection('users').doc(userId);
    await docRef.set({
      'lastBackup': FieldValue.serverTimestamp(),
      'categories': categories,
      'expenses': expenses,
      'accounts': accounts,
      'savings': savings,
    });
  }

  // Restore data
  Future<Map<String, dynamic>?> restoreData(String userId) async {
    final docSnapshot = await firestore.collection('users').doc(userId).get();
    if (docSnapshot.exists) {
      return docSnapshot.data();
    }
    return null;
  }
}
