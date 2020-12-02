import 'package:cafe_hollywood/models/meal.dart';
// import 'package:cafe_hollywood/screens/menu/meal_list.dart';
import 'package:cafe_hollywood/screens/menu/meal_tile.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MealListPage extends StatefulWidget {
  @override
  _MealListPageState createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  final List<Meal> mealList = [
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png'),
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png'),
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png'),
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png'),
  ];

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
    print('view cart');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    appBarHeight = screenSize.width * 9.0 / 16.0;
    return CupertinoPageScaffold(
      child: Stack(children: [
        CustomScrollView(
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
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'title',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'subtitle',
                            style: TextStyle(
                                fontSize: 24,
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
                (context, index) => MealTile(mealList[index]),
                childCount: mealList.length,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: BlackButton('View Cart', viewCartButtonHandler),
            ),
          ),
        ),
      ]),
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
