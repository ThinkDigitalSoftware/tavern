import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class PubHeader extends StatefulWidget implements PreferredSizeWidget {
  @override
  _PubHeaderState createState() => _PubHeaderState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 50);
}

class _PubHeaderState extends State<PubHeader> {
  int _currentSelection = 2;

  @override
  Widget build(BuildContext context) {
    Map<int, Widget> _children = {
      0: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
        child: Center(child: Text('Flutter')),
      ),
      1: Text('Web'),
      2: Text('All'),
    };
    return Material(
      color: Color.fromRGBO(18, 32, 48, 1),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: MaterialSegmentedControl(
          children: _children,
          selectionIndex: _currentSelection,
          borderColor: Color.fromRGBO(71, 99, 132, 1),
          selectedColor: Theme
              .of(context)
              .accentColor,
          unselectedColor: Color.fromRGBO(18, 32, 48, 1),
          borderRadius: 5.0,
          onSegmentChosen: (index) {
            setState(() {
              _currentSelection = index;
            });
          },
        ),
      ),
    );
  }
}
