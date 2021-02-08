import 'package:cafe_hollywood/models/menu.dart';
import 'package:cafe_hollywood/screens/menu/menuGridView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _sliding = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: new NestedScrollView(
          physics: ScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: Colors.white,
                // title: Text("Menu"),
                // floating: true,
                toolbarHeight: 0,
                // forceElevated: true,
                pinned: true,
                // snap: false,
                bottom: new TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Foods',
                    ),
                    Tab(text: 'Drinks')
                  ],
                ),
              ),
            ];
          },
          body: new TabBarView(children: [
            StreamProvider<List<Menu>>.value(
                value: FSService().foodMenuSnapshots, child: MenuGridView()),
            StreamProvider<List<Menu>>.value(
                value: FSService().drinkMenuSnapshots, child: MenuGridView()),
            // MenuGridView(l1),
          ] // <--- the array item is a ListView
              ),
        ),
      ),
    );
  }
}
