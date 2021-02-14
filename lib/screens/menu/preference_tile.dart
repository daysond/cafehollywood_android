import 'dart:math';
import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:cafe_hollywood/screens/menu/item_tile.dart';
import 'package:flutter/material.dart';

class PreferenceTile extends StatefulWidget {
  final Preference preference;
  void Function() updatePage;
  PreferenceTile(this.preference, this.updatePage);
  @override
  _PreferenceTileState createState() => _PreferenceTileState();
}

class _PreferenceTileState extends State<PreferenceTile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  // bool isExpanded = true;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    final _curve = CurvedAnimation(
        curve: Curves.easeIn,
        parent: _controller,
        reverseCurve: Curves.easeOut);

    _animation = Tween<double>(begin: pi / 4, end: 0).animate(_curve)
      ..addListener(() {
        setState(() {});
      });

    _controller.reverse();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void itemOnTap(String uid) {
    print('did tap on' + uid);
    PreferenceItem item = widget.preference.preferenceItems
        .firstWhere((element) => element.uid == uid);
    final int maxPick = widget.preference.maxPick;
    final int maxItemQuantity = widget.preference.maxItemQuantity;

    if (maxPick == 1 && maxItemQuantity == 1) {
      item.isSelected = !item.isSelected;

      widget.preference.preferenceItems.forEach((item) {
        if (item.uid != uid) {
          item.isSelected = false;
        }
      });
    } else if (maxPick == 1 && maxItemQuantity > 1) {
      item.isSelected = true;
    } else {
      // maxPick = items.length, maxItemQuantity = 1
      item.isSelected = !item.isSelected;
    }

    widget.updatePage();
  }

  void itemDidChangeQuantity(String uid, bool increased) {
    PreferenceItem item = widget.preference.preferenceItems
        .firstWhere((element) => element.uid == uid);

    switch (increased) {
      case true:
        {
          item.quantity++;
        }
        break;
      case false:
        {
          if (item.quantity == 1) {
            item.isSelected = false;
          } else if (item.quantity > 1) {
            item.quantity--;
          }
        }
        break;
    }
    widget.updatePage();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ExpansionTile(
        backgroundColor: Colors.grey[200],
        initiallyExpanded: true,
        title: Text(
          widget.preference.isRequired
              ? widget.preference.name + ' (Required)'
              : widget.preference.name,
          style: TextStyle(color: Colors.black),
        ),
        trailing: Transform.rotate(
          angle: _animation.value,
          child: Icon(
            Icons.add,
            size: 25,
            color: Colors.black,
          ),
        ),
        onExpansionChanged: (status) {
          // print(status);
          setState(() {
            status ? _controller.reverse() : _controller.forward();
          });
        },
        children: _buildItemTiles(widget.preference),
      ),
    );
  }

  _buildItemTiles(Preference preference) {
    List<Widget> content = [];
    for (PreferenceItem item in preference.preferenceItems) {
      content.add(
          new ItemTile(item, preference, itemOnTap, itemDidChangeQuantity));
    }
    return content;
  }
}
