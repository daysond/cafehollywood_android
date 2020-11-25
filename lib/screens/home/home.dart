import 'package:cafe_hollywood/screens/home/account_setting.dart';
import 'package:cafe_hollywood/screens/home/booking_panel.dart';
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
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: panel,
          );
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
      navigationBar: CupertinoNavigationBar(
        trailing: GestureDetector(
            onTap: () {
              print('open menu');
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AccountSettingPage()));
            },
            child: Icon(CupertinoIcons.bars, color: Colors.white)),
        backgroundColor: Colors.white.withOpacity(0.0),
      ),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/homebg.png'), fit: BoxFit.cover)),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                onPressed: () {},
                child: Text('Online Order Now'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
