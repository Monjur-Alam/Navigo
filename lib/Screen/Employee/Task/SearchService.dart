import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'items';
  Future<List<DocumentSnapshot>> getSearch(
      String documentID, String subID) async =>
      await _firestore
          .collection("contact")
          .doc(documentID)
          .collection("contact")
      // .where("searchKey")
          .get()
          .then((snaps) {
        return snaps.docs;
      });
}