import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:flutter/material.dart';
import 'package:cafe_hollywood/models/preference.dart';

class ItemTile extends StatefulWidget {
  final PreferenceItem item;
  final Preference preference;
  final void Function(String) handleOnTap;
  final void Function(String, bool) shouldIncreaseItemQuantity;

  ItemTile(this.item, this.preference, this.handleOnTap,
      this.shouldIncreaseItemQuantity);
  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    int maxPick = widget.preference.maxPick;
    int maxItemQuantity = widget.preference.maxItemQuantity;

    if (maxPick == 1 && maxItemQuantity == 1) {
      return GestureDetector(
        onTap: () {
          widget.handleOnTap(widget.item.uid);
        },
        child: Card(
          //Single item
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                widget.item.isSelected ? Icon(Icons.check) : SizedBox(width: 0),
                SizedBox(width: 8),
                Text(widget.item.name),
                new Spacer(),
                if (widget.item.price != null) Text('\$${widget.item.price}'),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
      );
    } else if (maxPick == 1 && maxItemQuantity > 1) {
      return GestureDetector(
        onTap: () {
          // if it's not selected, selected the item,
          // if it's selected, do nothing, shall use + or - to adjust quantity
          // minimum/ default quantity is 1
          if (!widget.item.isSelected) {
            widget.handleOnTap(widget.item.uid);
          }
        },
        child: Card(
          //Mulitple items
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.item.isSelected
                ? Row(
                    children: [
                      GestureDetector(
                          onTap: () => widget.shouldIncreaseItemQuantity(
                              widget.item.uid, true),
                          child: Icon(Icons.add)),
                      Text(widget.item.quantity.toString()),
                      GestureDetector(
                          onTap: () => widget.shouldIncreaseItemQuantity(
                              widget.item.uid, false),
                          child: Icon(Icons.remove)),
                      SizedBox(width: 8),
                      Text(widget.item.name),
                      new Spacer(),
                      if (widget.item.price != null)
                        Text('\$${widget.item.price}'),
                      SizedBox(width: 8),
                    ],
                  )
                : Row(
                    children: [
                      SizedBox(width: 8),
                      Text(widget.item.name),
                      new Spacer(),
                      if (widget.item.price != null)
                        Text('\$${widget.item.price}'),
                      SizedBox(width: 8),
                    ],
                  ),
          ),
        ),
      );
    } else {
      // maxPick = items.length, maxItemQuantity = 1
      return GestureDetector(
        onTap: () {
          widget.handleOnTap(widget.item.uid);
        },
        child: Card(
          //Single item
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                widget.item.isSelected ? Icon(Icons.check) : SizedBox(width: 0),
                SizedBox(width: 8),
                Text(widget.item.name),
                new Spacer(),
                if (widget.item.price != null) Text('\$${widget.item.price}'),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
      );
    }

    // return widget.enableMultiPick
    //     ? GestureDetector(
    //         onTap: () => widget.item.quantity++,
    //         child: Card(
    //           //Mulitple items
    //           elevation: 0,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Row(
    //               children: [
    //                 Icon(Icons.add),
    //                 Text(widget.item.quantity.toString()),
    //                 Icon(Icons.remove),
    //                 SizedBox(width: 8),
    //                 Text(widget.item.name),
    //                 new Spacer(),
    //                 if (widget.item.price != null)
    //                   Text('\$${widget.item.price}'),
    //                 SizedBox(width: 8),
    //               ],
    //             ),
    //           ),
    //         ),
    //       )
    //     : GestureDetector(
    //         onTap: () {
    //           setState(() {
    //             widget.item.isSelected = !widget.item.isSelected;
    //           });
    //         },
    //         child: Card(
    //           //Single item
    //           elevation: 0,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Row(
    //               children: [
    //                 widget.item.isSelected
    //                     ? Icon(Icons.add)
    //                     : SizedBox(width: 0),
    //                 SizedBox(width: 8),
    //                 Text(widget.item.name),
    //                 new Spacer(),
    //                 if (widget.item.price != null)
    //                   Text('\$${widget.item.price}'),
    //                 SizedBox(width: 8),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
  }
}
