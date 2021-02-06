import 'package:cafe_hollywood/models/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FSService {
  Stream<List<Menu>> get drinkMenuSnapshots {
    print('getting drink menu');
    return FirebaseFirestore.instance
        .collection('drinkMenu')
        .snapshots()
        .map<List<Menu>>(_menuListFromSnapshot);
  }

  Stream<List<Menu>> get foodMenuSnapshots {
    return FirebaseFirestore.instance
        .collection('foodMenu')
        .snapshots()
        .map<List<Menu>>(_menuListFromSnapshot);
  }

  List<Menu> _menuListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map<Menu>((doc) {
      String uid = doc.id;
      String menuTitle = doc.data()['menuTitle'];
      String imageURL = doc.data()['imageURL'];
      String menuDetail = doc.data()['menuDetail'];
      List<String> mealsInUID = (doc.data()['mealsInUID'] as List)
          .map((uid) => uid as String)
          .toList();
      bool isTakeOutOnly = doc.data()['isTakeOutOnly'];

      Menu menu = Menu(uid, menuTitle, mealsInUID, '${imageURL}.png',
          isTakeOutOnly, menuDetail);

      return menu;
    }).toList();
  }
}
