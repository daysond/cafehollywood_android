import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  final PreferenceItem item;
  bool enableMultiPick;
  int maxPick;
  int maxQuantity;
  ItemTile(this.item, this.enableMultiPick, this.maxPick, this.maxQuantity);
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
              color: Colors.amber,
              //Single item
              elevation: 0,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    width: 40,
                    top: 8,
                    bottom: 8,
                    child: _handleSelection(),
                  ),
                  Positioned(
                    top: 8,
                    left: 40,
                    right: 8,
                    bottom: 8,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.item.name),
                          new Spacer(),
                          Text('\$${widget.item.price}'),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _handleSelection() {
    if (widget.item.isSelected) {
      return Icon(
        Icons.add,
        // size: 32,
      );
    } else {
      return SizedBox(width: 0);
    }
  }
}
