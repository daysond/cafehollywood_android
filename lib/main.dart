import 'package:cafe_hollywood/screens/MainTab/main_tab.dart';
import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';

import 'package:cafe_hollywood/screens/wrapper.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // runApp(MainTabBar());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTabBar();
    // return StreamProvider<String>.value(
    //     value: AuthService().currentUserID,
    //     child: CupertinoApp(
    //       localizationsDelegates: [
    //         DefaultMaterialLocalizations.delegate,
    //         DefaultCupertinoLocalizations.delegate,
    //         DefaultWidgetsLocalizations.delegate,
    //       ],
    //       home: Wrapper(),
    //       title: "Cafe Hollywood",
    //       theme: CupertinoThemeData(
    //         primaryColor: Colors.black,
    //         textTheme: CupertinoTextThemeData(
    //           navLargeTitleTextStyle: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 60,
    //             color: CupertinoColors.white,
    //           ),
    //         ),
    //       ),
    //     )
    //     // MaterialApp(
    //     //   home: Wrapper(),
    //     //   theme: ThemeData(primarySwatch: Colors.green),
    //     // ),
    //     );
  }
}
