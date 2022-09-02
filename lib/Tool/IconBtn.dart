import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  const IconBtn({Key? key, required this.child, required this.color})
      : super(key: key);
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: child,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1),
        ));
  }
}
