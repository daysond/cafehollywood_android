import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';
import 'package:cafe_hollywood/screens/auth_screens/setting_page.dart';

import 'package:cafe_hollywood/screens/home/booking_panel.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'quick_order_list_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showPanel(Widget panel) {
    showModalBottomSheet(
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
      // navigationBar: CupertinoNavigationBar(
      //   trailing: GestureDetector(
      //       onTap: () {
      //         print('open menu');
      //         Navigator.push(
      //             context,
      //             CupertinoPageRoute(
      //                 builder: (context) => AccountSettingPage()));
      //       },
      //       child: Icon(CupertinoIcons.bars, color: Colors.white)),
      //   backgroundColor: Colors.white.withOpacity(0.0),
      // ),
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
                      child: RaisedButton(
                        onPressed: () => _showPanel(QuickOrderListView()),
                        child: Text('Quick Order'),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ButtonTheme(
                      minWidth: 145,
                      buttonColor: Colors.white,
                      child: RaisedButton(
                        onPressed: () => _showPanel(BookingPanel()),
                        child: Text('Make Reservation'),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ButtonTheme(
                      minWidth: 145,
                      buttonColor: Colors.white,
                      child: RaisedButton(
                        onPressed: () {
                          var name = AuthService().displayName;
                          print(name);
                        },
                        child: Text('Online Order Now'),
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
