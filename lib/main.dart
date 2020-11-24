import 'package:cafe_hollywood/screens/MainTab/menu/menuPage.dart';
import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';
import 'package:cafe_hollywood/screens/MainTab/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // runApp(MainTabBar());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MainTabBar(),
    theme: ThemeData(primarySwatch: Colors.green),
  ));
}

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );
    return CupertinoApp(
      home: HomeScreen(),
      theme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 60,
            color: CupertinoColors.systemRed,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              // iconSize: 30,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.list_bullet), label: 'Menu'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.list_bullet), label: 'Menu'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.money_dollar), label: 'Orders'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.cart), label: 'Cart'),
              ],
            ),
            tabBuilder: (context, index) {
              return CupertinoTabView(builder: (context) {
                switch (index) {
                  case 0:
                    return HomePage();
                  case 1:
                    return MaterialApp(
                      home: MenuPage(),
                    );
                  default:
                    return CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle: Text(index.toString()),
                        ),
                        child: Center(
                            child: CupertinoButton(
                          child: Text(
                            'this is button $index',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .actionTextStyle
                                .copyWith(fontSize: 32),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(CupertinoPageRoute(builder: (context) {
                              return DetailScreen(index.toString());
                            }));
                          },
                        )));
                }
              });
            }),
        Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              elevation: 0,
              onPressed: () {
                //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                print('pressed');
              },
            )),
      ],
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen(this.topic);
  final String topic;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Details'),
      ),
      child: Center(
        child: Text('details for ${widget.topic}'),
      ),
    );
  }
}
