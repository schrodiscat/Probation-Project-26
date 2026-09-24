import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference favoritesRef =
      FirebaseFirestore.instance.collection('favorite_cities');

  Future<void> addFavorite(String cityName) async {
    final querySnapshot = await favoritesRef
        .where('cityName', isEqualTo: cityName.toLowerCase())
        .get();

    if (querySnapshot.docs.isEmpty) {
      await favoritesRef.add({
        'cityName': cityName.toLowerCase(),
        'createdAt': Timestamp.now(),
      });
    } else {
      throw Exception('City is already in favorites!');
    }
  }

  
  Future<void> removeFavorite(String docId) async {
    await favoritesRef.doc(docId).delete();
  }


  Stream<QuerySnapshot> getFavoritesStream() {
    return favoritesRef.orderBy('createdAt', descending: true).snapshots();
  }
}