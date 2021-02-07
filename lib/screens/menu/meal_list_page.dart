import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/models/menu.dart';
import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:cafe_hollywood/screens/menu/meal_tile.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/models/cart.dart';
import 'package:provider/provider.dart';

class MealListPage extends StatefulWidget {
  final Menu menu;
  MealListPage(this.menu);

  @override
  _MealListPageState createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  ScrollController _scrollController;

  bool lastStatus = true;
  double appBarHeight = 0;
  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (appBarHeight - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void viewCartButtonHandler() {
    // setState(() {});
    var meal = Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png');
    Cart().addMealToCart(meal);
    print('view cart ${Cart().meals.length} ${Cart().cartTotal}');
  }

  Future<List<Meal>> getMeals() async {
    List<Meal> meals = [];
    var futures = List<Future<Meal>>();

    widget.menu.mealsInUID.forEach((uid) {
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
        var meal = Meal(value.id, data['name'],
            Decimal.parse('${data['price']}'), data['description'],
            details: data['detail']);
        if (data['comboTag'] != null) {
          meal.comboMealTag = data['comboTag'];
        }
        if (data['imageURL'] != null) {
          meal.imageURL = '${data['imageURL']}.jpg';
        }
        if (data['isBOGO'] != null) {
          meal.isBogo = data['isBOGO'];
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
            PreferenceItem(data['uid'], data['name'], data['description']);
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

  @override
  Widget build(BuildContext context) {
    print(widget.menu.mealsInUID);

    Size screenSize = MediaQuery.of(context).size;
    appBarHeight = screenSize.width * 9.0 / 16.0;
    return ChangeNotifierProvider.value(
      value: Cart(),
      // create: (_) => Cart(),
      child: CupertinoPageScaffold(
        child: Stack(children: [
          FutureBuilder<List<Meal>>(
              future: getMeals(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: isShrink ? Colors.black : Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        expandedHeight: screenSize.width * 9.0 / 16.0,
                        backgroundColor: Colors.white,
                        title: Text(isShrink ? 'Menu A' : '',
                            style: TextStyle(
                              color: isShrink ? Colors.black : Colors.white,
                            )),
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: false,
                          background: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350"),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 32, 32, 16),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.menu.menuTitle,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      widget.menu.menuDetail,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => MealTile(snapshot.data[index]),
                          childCount: snapshot.data.length,
                        ),
                      ),
                      // ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text('Loading'),
                  );
                }
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Consumer<Cart>(builder: (context, cart, child) {
                  return BlackButton('View Cart', viewCartButtonHandler,
                      subtitle: '\$${cart.cartTotal.toString()}');
                }),
              ),
            ),
          ),
        ]),
      ),
    );

    // CupertinoPageScaffold(
    //   navigationBar: CupertinoNavigationBar(
    //     backgroundColor: null,
    //     leading: CupertinoNavigationBarBackButton(
    //       color: Colors.black,
    //       onPressed: () => Navigator.pop(context),
    //     ),
    //   ),
    //   child: MealList(),
    // );
  }
}
