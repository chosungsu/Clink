import 'package:flutter/material.dart';

class ContainerDesign extends StatelessWidget {
  const ContainerDesign({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: child,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black54.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(1, 1)),
              BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-1, -1)),
            ]));
  }
}
