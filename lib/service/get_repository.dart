import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_bloc/model/postModel.dart';

class GetApiRepository {
  final _firebase = FirebaseFirestore.instance.collection('user');
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  Future<List<FirebaseModel>> getData() async {
    List<FirebaseModel> getDataList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await users.get() as QuerySnapshot<Map<String, dynamic>>;
      querySnapshot.docs.forEach((element) {
        print(element.data());
        getDataList.add(FirebaseModel.fromJson(element.data()));
      });

    } catch (e) {
      print(e.toString());

      throw Exception(e.toString());
    }
    return getDataList;
  }
}
