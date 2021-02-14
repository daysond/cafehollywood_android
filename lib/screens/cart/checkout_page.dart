import 'package:cafe_hollywood/models/custom_option.dart';
import 'package:cafe_hollywood/screens/cart/checkout_option_tile.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cafe_hollywood/screens/cart/cart_total_widget.dart';
import 'package:cafe_hollywood/models/cart.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final instructionTextController = TextEditingController();
  void handlePlaceOrder() async {
    await FSService().placeOrder();

    // Navigator.pop(context);
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
    Cart().resetCart();
  }

  void handleNotesTapped(CustomOption option) {
    if (option.subTitle != '(Any food alergy?)') {
      print(option.subTitle);
      instructionTextController.text = option.subTitle;
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              // color: Colors.red,
              child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Flexible(
                child: CupertinoTextField(
                  controller: instructionTextController,
                  autofocus: true,
                  maxLines: 8,
                  placeholder: 'Special Instructions',
                ),
              ),
              SizedBox(height: 8),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                    FlatButton(
                        onPressed: () {
                          if (instructionTextController.text != '') {
                            setState(() {
                              Cart().orderNote = instructionTextController.text;
                              option.subTitle = Cart().orderNote;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Done'))
                  ])
            ]),
          ));
        });
  }

  void handleOptionTap(CustomOption option) {
    setState(() {
      switch (option.optionType) {
        case OptionType.utensil:
          Cart().needsUtensil = !Cart().needsUtensil;
          option.subTitle =
              !Cart().needsUtensil ? 'No. Thanks!' : 'Yes please!';
          break;
        case OptionType.scheduler:
          print('schedule tapped');
          break;
        case OptionType.note:
          print('note tapped');
          handleNotesTapped(option);

          // opens a modal sheet for note input
          break;
        default:
          break;
      }
    });
  }

  CustomOption cutlery = CustomOption(
      'UTENSILS, STRAWS, ETC',
      'cutlery',
      Cart().needsUtensil == true ? 'Yes please!' : 'No. Thanks!',
      OptionType.utensil);
  CustomOption pickupTime =
      CustomOption('PICK UP TIME', 'clock', 'Now', OptionType.scheduler);
  CustomOption note = CustomOption(
      'NOTE',
      'notes',
      Cart().orderNote == null || Cart().orderNote == ''
          ? '(Any food alergy?)'
          : Cart().orderNote,
      OptionType.note);

  @override
  Widget build(BuildContext context) {
    final List<CustomOption> options = [cutlery, pickupTime, note];
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: new NestedScrollView(
              physics: ScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Summary',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                    floating: true,
                    // toolbarHeight: 80,
                    // forceElevated: true,
                    pinned: true,

                    // snap: false,
                  ),
                ];
              },
              body: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return CheckoutOptionTile(
                            options[index], handleOptionTap);
                      }),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8.0, 16),
                child: CartTotalPanel()),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: BlackButton('Place Order', handlePlaceOrder, true)),
        ],
      ),
    ));
  }
}
