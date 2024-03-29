import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';
import 'package:cafe_hollywood/screens/auth_screens/setting_page.dart';

import 'package:cafe_hollywood/screens/home/booking_panel.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'quick_order_list_view.dart';

class HomePage extends StatefulWidget {
  final void Function() onlineOrderTapped;
  HomePage(this.onlineOrderTapped);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showPanel(Widget panel, bool isScrollControlled) {
    showModalBottomSheet(
        isScrollControlled: isScrollControlled,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        context: context,
        builder: (context) {
          return SafeArea(child: panel);
        });
  }

  void _showAuthHome() {
    showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        context: context,
        builder: (context) {
          return SafeArea(child: AuthHomePage());
        });
  }

  // void _showQuickOrderPanel() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
  //           child: QuickOrderListView(),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/homebg.png'), fit: BoxFit.cover)),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      minWidth: 145,
                      buttonColor: Colors.white,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, minimumSize: Size(145, 40)),
                        onPressed: () => _showPanel(QuickOrderListView(), true),
                        child: Text(
                          'Quick Order',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ButtonTheme(
                      minWidth: 145,
                      buttonColor: Colors.white,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, minimumSize: Size(145, 40)),
                        onPressed: () => _showPanel(BookingPanel(), false),
                        child: Text('Make Reservation',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ButtonTheme(
                      minWidth: 145,
                      buttonColor: Colors.white,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, minimumSize: Size(145, 40)),
                        onPressed: widget.onlineOrderTapped,
                        child: Text('Online Order Now',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ]),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () {
                    AuthService().isAuth
                        ? Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SettingPage()))
                        : _showAuthHome();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 16),
                    child: Icon(
                      CupertinoIcons.bars,
                      color: Colors.white,
                      size: 40,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
