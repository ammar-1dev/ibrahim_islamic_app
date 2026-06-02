import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/local_storage.dart';

class BookmarkSync {
  final _storage = LocalStorage();
  final _firestore = FirebaseFirestore.instance;

  Future<void> syncToCloud(String userId) async {
    final bookmarks = _storage.getBookmarks();
    await _firestore.collection('users').doc(userId).set({
      'bookmarks': bookmarks,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> syncFromCloud(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists && doc.data()?.containsKey('bookmarks') == true) {
      final cloudBookmarks = List<String>.from(doc.data()!['bookmarks']);
      final localBookmarks = _storage.getBookmarks();
      final merged = {...localBookmarks, ...cloudBookmarks}.toList();
      for (final b in merged) {
        if (!localBookmarks.contains(b)) {
          _storage.addBookmark(b);
        }
      }
    }
  }
}

final bookmarkSyncProvider = Provider<BookmarkSync>((ref) {
  return BookmarkSync();
});
