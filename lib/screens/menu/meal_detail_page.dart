import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:cafe_hollywood/screens/menu/item_tile.dart';
import 'package:cafe_hollywood/screens/menu/preference_tile.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';

class MealDetailPage extends StatefulWidget {
  final Meal meal;
  final bool isNewMeal;
  final bool modifyMode;
  void Function()? modifierCallBack;

  MealDetailPage(this.meal, this.isNewMeal, this.modifyMode,
      {this.modifierCallBack});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  ScrollController? _scrollController;
  final instructionTextController = TextEditingController();
  bool lastStatus = true;
  double appBarHeight = 0;
  bool shouldHideBlackButton = false;
  bool shouldEnableCartButton = false;
  bool get isShrink {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (appBarHeight - kToolbarHeight);
  }

  bool isFav = false;

  bool get hasImage {
    return widget.meal.imageURL != null;
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
    _scrollController!.addListener(_scrollListener);
    getIsFav();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_scrollListener);
    super.dispose();
  }

  getIsFav() async {
    await widget.meal.isFavourite().then((value) {
      setState(() {
        isFav = value;
      });
    });
  }

  void cartButtonTapped() {
    if (widget.isNewMeal) {
      Meal newMeal = widget.meal.copy(widget.meal);
      Cart().addMealToCart(newMeal);
      resetMeal();
    } else {
      Cart().didUpdateCart();
    }

    Navigator.pop(context);
  }

  void saveModification() {
    widget.modifierCallBack!.call();
    Navigator.pop(context);
  }

  void resetMeal() {
    widget.meal.quantity = 1;
    widget.meal.preferences?.forEach((preference) {
      preference.isSectionCollapsed = false;
      preference.preferenceItems.forEach((item) {
        item.quantity = 1;
        item.isSelected = false;
      });
    });
  }

  void didUpdatePreference() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    appBarHeight = screenSize.width * 9.0 / 16.0;

    if (widget.meal.preferences == null) {
      shouldEnableCartButton = true;
    } else {
      for (Preference preference in widget.meal.preferences!) {
        if (preference.isRequired) {
          for (PreferenceItem preferenceItem in preference.preferenceItems) {
            // if item is selected, stop searching and move onto next
            if (preferenceItem.isSelected == true) {
              shouldEnableCartButton = true;
              break;
            } else {
              shouldEnableCartButton = false;
            }
          }

          if (shouldEnableCartButton == false) {
            break;
          }
        } else {
          shouldEnableCartButton = true;
        }
      }
      ;
    }

    if (!widget.isNewMeal && widget.meal.instruction != null) {
      instructionTextController.text = widget.meal.instruction!;
    }

    return CupertinoPageScaffold(
      child: Stack(children: [
        CustomScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          slivers: [
            SliverAppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: hasImage ? Colors.white : Colors.black,
                    size: 36,
                  ),
                  color: isShrink ? Colors.black : Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(isShrink ? widget.meal.name : '',
                  style: TextStyle(
                    color: isShrink ? Colors.black : Colors.white,
                  )),
              backgroundColor: Colors.white,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                // title: Text('This is my menu'),
                background: Container(
                  decoration: widget.meal.imageURL != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage('assets/${widget.meal.imageURL!}'),
                          ),
                        )
                      : null,
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: hasImage
                              ? LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                      Colors.grey.withOpacity(0.0),
                                      Colors.black.withOpacity(0.9),
                                    ],
                                  stops: [
                                      0.0,
                                      1.0
                                    ])
                              : null),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 32, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.meal.name,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: hasImage
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    widget.meal.details,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: hasImage
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () async {
                                if (isFav) {
                                  APPSetting().unfavouriteMeal(widget.meal.uid);
                                } else {
                                  APPSetting().favouriteMeal(widget.meal.uid);
                                }
                                setState(() {
                                  isFav = !isFav;
                                });
                              },
                              child: ImageIcon(
                                AssetImage('assets/heartEmpty.png'),
                                color: isFav ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              expandedHeight: hasImage
                  ? MediaQuery.of(context).size.width * 9.0 / 16.0
                  : 120,
            ),
            if (widget.meal.preferences != null)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PreferenceTile(
                      widget.meal.preferences![index], didUpdatePreference),
                  childCount: widget.meal.preferences!.length,
                ),
              ),
            SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildPreferenceFooter();
                  },
                  childCount: 1,
                ),
                itemExtent: 300),
          ],
        ),
        if (!shouldHideBlackButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: widget.modifyMode
                    ? BlackButton(
                        'Save Modification',
                        saveModification,
                        shouldEnableCartButton,
                        subtitle:
                            '\$${widget.meal.totalPrice.toStringAsFixed(2)}',
                      )
                    : BlackButton(
                        widget.isNewMeal ? 'Add To Cart' : 'Update Cart',
                        cartButtonTapped,
                        shouldEnableCartButton,
                        subtitle:
                            '\$${widget.meal.totalPrice.toStringAsFixed(2)}',
                      ),
              ),
            ),
          ),
      ]),
    );
  }

  _buildPreferenceFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Special Instructions:'),
          SizedBox(height: 8),
          CupertinoTextField(
            placeholder: 'Any Special Instructions?',
            controller: instructionTextController,
            onTap: () {
              setState(() {
                shouldHideBlackButton = true;
              });
            },
            onEditingComplete: () {
              setState(() {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                shouldHideBlackButton = false;
                if (instructionTextController.text != '') {
                  widget.meal.instruction = instructionTextController.text;
                }
              });
            },
          ),
          // TextButton(
          //     onPressed: () {
          //       print('go to special instruction');
          //     },
          //     child: Text(
          //       'Special instructions?',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Colors.grey,
          //       ),
          //     )),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.meal.quantity++;
                    });
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 16),
                Text(widget.meal.quantity.toString()),
                SizedBox(width: 16),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.meal.quantity > 1) {
                          widget.meal.quantity--;
                        }
                      });
                    },
                    child: Icon(Icons.remove)),
              ],
            ),
          ),
          if (!widget.isNewMeal)
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  onPressed: () {
                    Cart().removeMeal(widget.meal);
                    Navigator.pop(context);
                    print('removing');
                  },
                  child: Text(
                    'Remove Item',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
