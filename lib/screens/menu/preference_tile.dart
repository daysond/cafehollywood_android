import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:cafe_hollywood/screens/menu/item_tile.dart';
import 'package:flutter/material.dart';

class PreferenceTile extends StatefulWidget {
  final Preference preference;
  PreferenceTile(this.preference);
  @override
  _PreferenceTileState createState() => _PreferenceTileState();
}

class _PreferenceTileState extends State<PreferenceTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ExpansionTile(
        backgroundColor: Colors.grey[200],
        initiallyExpanded: true,
        title: Text(widget.preference.name),
        children: _buildItemTiles(widget.preference),
      ),
    );
  }

  _buildItemTiles(Preference preference) {
    List<Widget> content = [];
    for (PreferenceItem item in preference.preferenceItems) {
      content.add(new ItemTile(item, preference.maxItemQuantity > 1));
    }
    return content;
  }
}
