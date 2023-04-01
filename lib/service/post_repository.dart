import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PostApiRepository {
  final _firebase = FirebaseFirestore.instance.collection('user');

  Future<void> addData(
      String title, String description, String location, String date) async {
    try {
      await _firebase.add({
        'problemTitle': title,
        'problemDescription': description,
        'problemLocation': location,
        'date': date
      });
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
