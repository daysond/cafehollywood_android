import 'dart:async';

import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/models/enums/combo_type.dart';
import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:cafe_hollywood/models/menu.dart';
import 'package:cafe_hollywood/models/order_manager.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/models/table.dart';
import 'package:cafe_hollywood/models/table_order.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:decimal/decimal.dart';
import 'package:cafe_hollywood/models/meal.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class FSService {
  static FSService _instance;
  FSService._internal() {
    _instance = this;
  }

  factory FSService() => _instance ?? FSService._internal();

  StreamSubscription<DocumentSnapshot> activeTableListener;

  final databaseRef = FirebaseFirestore.instance;
  String randomString(int strlen) {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

// MENU
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

  Future<List<Meal>> getMeals(List<String> uids) async {
    List<Meal> meals = [];
    var futures = List<Future<Meal>>();

    uids.forEach((uid) {
      futures.add(getMeal(uid));
    });

    await Future.wait(futures).then((result) {
      meals = result;
    });
    return meals;
  }

  Future<Meal> getMeal(String uid) async {
    var doc = FirebaseFirestore.instance.collection('meals').doc(uid);
    return doc.get().then((value) async {
      if (value.data() != null) {
        final data = value.data();

        var meal = Meal(
            value.id,
            data['name'],
            Decimal.parse('${data['price']}'),
            data['description'],
            data['detail']);
        if (data['comboTag'] != null) {
          meal.comboMealTag = data['comboTag'];
        }
        if (data['imageURL'] != null) {
          meal.imageURL = '${data['imageURL']}.jpg';
        }
        if (data['isBOGO'] != null) {
          meal.isBogo = data['isBOGO'];
        }
        if (data['comboType'] != null) {
          int comboTypeInt = data['comboType'];
          meal.comboType = ComboTypeExt.comboTypeFromRawValue(comboTypeInt);
        }

        if (data['preferences'] != null) {
          var futures = List<Future<Preference>>();
          List<String> uids =
              (data['preferences'] as List).map((e) => e as String).toList();
          uids.forEach((uid) {
            futures.add(getPreference(uid));
          });

          await Future.wait(futures).then((preferences) {
            meal.preferences = preferences;
          });
        }

        return meal;
      }
    });
  }

  Future<Preference> getPreference(String uid) async {
    var futures = List<Future<PreferenceItem>>();
    var doc = FirebaseFirestore.instance.collection('preferences').doc(uid);
    var items = List<PreferenceItem>();
    return doc.get().then((value) async {
      if (value.data() != null) {
        final data = value.data();
        List<String> itemUIDs =
            (data['items'] as List).map((e) => e as String).toList();
        itemUIDs.forEach((uid) {
          futures.add(getPreferenceItem(uid));
        });

        await Future.wait(futures).then((result) {
          items = result;
        });

        Preference preference = Preference(value.id, data['isRequired'],
            data['name'], data['maxPick'], data['maxItemQuantity'], items);

        return preference;
      }
    });
  }

  Future<PreferenceItem> getPreferenceItem(String uid) async {
    var doc = FirebaseFirestore.instance.collection('preferenceItems').doc(uid);
    return doc.get().then((value) {
      if (value.data() != null) {
        final data = value.data();
        PreferenceItem item =
            PreferenceItem(value.id, data['name'], data['description']);
        if (data['price'] != null) {
          item.price = Decimal.parse('${data['price']}');
        }
        if (data['comboTag'] != null) {
          item.comboTag = data['comboTag'];
        }
        return item;
      }
    });
  }

//ONLINE ORDER
  Future placeOrder() async {
    final String orderID = randomString(6);
    final customerID = AuthService().customerID ?? 'newUser';
    // print('placing order ${orderID}');
    var orderRef = databaseRef.collection('onlineOrders').doc(orderID);
    var activeOrderRef = databaseRef.collection("activeOrders").doc(orderID);
    var customerActiveOrderRef = databaseRef
        .collection("customers")
        .doc(customerID)
        .collection("activeOrders")
        .doc(orderID);
    orderRef.set(Cart().representation).catchError((e) {
      //error handling
    });
    activeOrderRef.set({}).catchError((e) {
      //error handling
    });
    customerActiveOrderRef.set({
      'status': OrderStatus.unconfirmed.rawValue,
      'timestamp': Cart().orderTimestamp
    }).catchError((e) {
      //error handling
    });
  }

  Stream<QuerySnapshot> get activeOrderSnapshots {
    // print(APP)
    return databaseRef
        .collection("customers")
        .doc(APPSetting().customerUID)
        .collection("activeOrders")
        .snapshots();
  }

  Future<List<Receipt>> getPastReceipts() async {
    var customerOrdersRef = databaseRef
        .collection('customers')
        .doc(APPSetting().customerUID)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .limitToLast(10);

    var futures = List<Future<Receipt>>();

    var receipts = List<Receipt>();

    return customerOrdersRef.get().then((value) async {
      if (value.docs != null) {
        final docs = value.docs;

        docs.forEach((doc) {
          futures.add(getReceipt(doc.id));
        });

        await Future.wait(futures).then((result) {
          receipts = result;
        });
        print('did get receipts');
        OrderManager().addRecepits(receipts);
        return receipts;
      }
    });
  }

  Future<Receipt> getReceipt(String id) async {
    var doc = databaseRef.collection('onlineOrders').doc(id);
    return doc.get().then((value) {
      if (value.data() != null) {
        final data = value.data();
        // Receipt receipt = Receipt

        String customerID = data['customerID'];

        String orderTimestamp = data['orderTimestamp'];
        String orderNote = data['orderNote'];
        Decimal discount = Decimal.parse('${data['discount']}' ?? '0');
        Decimal promotion = Decimal.parse('${data['promotion']}' ?? '0');
        Decimal taxes = Decimal.parse('${data['taxes']}' ?? '0');
        Decimal subtotal = Decimal.parse('${data['subtotal']}' ?? '0');
        Decimal total = Decimal.parse('${data['total']}' ?? '0');
        int orderStatusInt = data['status'];
        String customerName = data['customerName'];
        OrderStatus orderStatus =
            OrderStatusExt.statusFromRawValue(orderStatusInt);
        List<Map> mealsInfoMap = (data['mealsInfo'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        List<MealInfo> mealInfoList = [];

        mealsInfoMap.asMap().forEach((index, info) {
          if (info['uid'] != null) {
            MealInfo mealInfo =
                _mealsInfoFromData('${index}-${info['uid']}', info);
            mealInfoList.add(mealInfo);
          }
        });

        Receipt receipt = Receipt(
            doc.id,
            customerID,
            orderTimestamp,
            orderNote,
            discount,
            promotion,
            subtotal,
            taxes,
            total,
            mealInfoList,
            orderStatus,
            customerName);
        return receipt;
      }
    });
  }

  MealInfo _mealsInfoFromData(String id, Map<String, dynamic> data) {
    String name = data['name'];
    int quantity = data['quantity'];
    Decimal totalPrice = Decimal.parse('${data['totalPrice']}' ?? '0');
    String addOnInfo = data['addOnInfo'];
    String instruction = data['instruction'];

    int comboTag = data['comboTag'];
    int comboTypeInt = data['comboType'];

    return MealInfo(
        id,
        name,
        quantity,
        totalPrice,
        addOnInfo,
        instruction,
        comboTypeInt == null
            ? null
            : ComboTypeExt.comboTypeFromRawValue(comboTypeInt),
        comboTag);
  }

  //TABLE
  Future<bool> checkIfTableDoesExist() {
    if (DineInTable().tableNumber == null) {
      return null;
    }

    String table = DineInTable().tableNumber;

    var activeTableRef = databaseRef.collection("activeTables").doc(table);

    return activeTableRef.get().then((value) {
      print('${value.data() == null}');
      return value.data() != null;
    });
  }

  Future sendOrder(BuildContext context) async {
    if (DineInTable().tableNumber == null || AuthService().customerID == null) {
      return null;
    }
    print('sending order for user ${AuthService().customerID}');
    addTableListener();

    final String orderID = randomString(6);

    var activeTableRef =
        databaseRef.collection("activeTables").doc(DineInTable().tableNumber);

    var ordersRef = databaseRef.collection("dineInOrders").doc(orderID);

    var customerActiveTableRef = databaseRef
        .collection("customers")
        .doc(AuthService().customerID)
        .collection("activeTables")
        .doc(DineInTable().tableNumber);

    ordersRef.set(Cart().dineInRepresentation).then((value) {
      activeTableRef.set(
          {orderID: OrderStatus.unconfirmed.rawValue}, SetOptions(merge: true));

      customerActiveTableRef.set({});

      Cart().resetCart();
      Navigator.pop(context);
    }).catchError((error) {
      print(error.toString());
    });
  }

  void addTableListener() {
    if (DineInTable().tableNumber == null) {
      return;
    }

    if (activeTableListener != null) {
      print('returned');
      return;
    }

    var activeTableRef =
        databaseRef.collection("activeTables").doc(DineInTable().tableNumber);

    activeTableListener = activeTableRef.snapshots().listen((snapshot) {
      var data = snapshot.data();
      print(data.toString());
      if (data.length == 0) {
        return;
      }
      data.forEach((key, value) {
        if (key == "isTableActive") {
          if (value as int == 0) {
            closeTable();
          }
        } else {
          if (!DineInTable().orderIDs.contains(key)) {
            fetchTableOrder(key);
          } else {
            // if order exists, check status
            OrderStatus status =
                OrderStatusExt.statusFromRawValue(value as int);
            if (status != null) {
              // if status changed, update status
              TableOrder order = DineInTable().tableOrders.firstWhere(
                  (order) => order.orderID == key && order.status != status);
              if (order != null) {
                order.status = status;
              }

              // NotificationCenter.default.post(name: .didUpdateDineInOrderStatus, object: nil)
              // in swift means TableOrderView. receiptTableView.reloadDate()
              // In flutter equals to update recepit widget
            }
          }
        }

        // check if order exists, if nil, then it's a new order, then we fetch it
      });
    });

    activeTableListener.onError((error) {
      print(error.toString());
    });
  }

  void closeTable() {
    if (DineInTable().tableNumber == null || AuthService().customerID == null) {
      return;
    }

    var customerActiveTableRef = databaseRef
        .collection("customers")
        .doc(AuthService().customerID)
        .collection("activeTables")
        .doc(DineInTable().tableNumber);

    customerActiveTableRef.delete();
    if (activeTableListener != null) {
      activeTableListener.cancel();
      activeTableListener = null;
    }
    DineInTable().reset();
  }

  Future fetchTableOrder(String orderID) {
    databaseRef.collection("dineInOrders").doc(orderID).get().then((snapshot) {
      if (snapshot.data() != null) {
        final data = snapshot.data();
        String customerID = data["customerID"];
        String customerName = data["customerName"];
        String customerPhoneNumber = data["customerPhoneNumber"];
        String orderTimestamp = data["orderTimestamp"];

        int orderStatusInt = data["status"];
        String table = data["table"];
        OrderStatus orderStatus =
            OrderStatusExt.statusFromRawValue(orderStatusInt);

        List<Map> mealsInfoMap = (data['mealsInfo'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        List<MealInfo> mealInfoList = [];

        mealsInfoMap.asMap().forEach((index, info) {
          if (info['uid'] != null) {
            MealInfo mealInfo =
                _mealsInfoFromData('${index}-${info['uid']}', info);
            mealInfoList.add(mealInfo);
          }
        });
        TableOrder order = TableOrder(
            orderID,
            customerID,
            customerName,
            customerPhoneNumber,
            orderTimestamp,
            mealInfoList,
            table,
            orderStatus);
        DineInTable().addOrder(order);
      }
    });
  }
}
