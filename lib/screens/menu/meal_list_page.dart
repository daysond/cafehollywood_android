import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/models/menu.dart';
import 'package:cafe_hollywood/screens/menu/meal_tile.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
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
    print('view cart ${Cart().meals.length} ${Cart().cartTotal}');
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
              future: FSService().getMeals(widget.menu.mealsInUID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 108),
                    child: CustomScrollView(
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
                          title: Text(isShrink ? widget.menu.menuTitle : '',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    ),
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
                  return BlackButton('View Cart', viewCartButtonHandler, true,
                      subtitle: '\$${cart.cartTotal.toString()}');
                }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
