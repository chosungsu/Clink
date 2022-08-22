import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';

class ContainerDesign extends StatelessWidget {
  const ContainerDesign({Key? key, required this.child, required this.color})
      : super(key: key);
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: child,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            color: color,
            boxShadow: [
              BoxShadow(
                  color: TextColor().withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(1, 1)),
              BoxShadow(
                  color: BGColor().withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-1, -1)),
            ]));
  }
}
