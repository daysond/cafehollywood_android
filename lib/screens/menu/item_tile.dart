import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  final PreferenceItem item;
  bool enableMultiPick;
  ItemTile(this.item, this.enableMultiPick);
  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return widget.enableMultiPick
        ? GestureDetector(
            onTap: () => widget.item.quantity++,
            child: Card(
              //Mulitple items
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text(widget.item.quantity.toString()),
                    Icon(Icons.remove),
                    SizedBox(width: 8),
                    Text(widget.item.name),
                    new Spacer(),
                    Text('\$${widget.item.price}'),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                widget.item.isSelected = !widget.item.isSelected;
              });
            },
            child: Card(
              //Single item
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    widget.item.isSelected
                        ? Icon(Icons.add)
                        : SizedBox(width: 0),
                    SizedBox(width: 8),
                    Text(widget.item.name),
                    new Spacer(),
                    Text('\$${widget.item.price}'),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          );
  }
}
