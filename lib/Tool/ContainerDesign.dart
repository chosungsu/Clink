import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/widgets.dart';

class ContainerDesign extends StatelessWidget {
  const ContainerDesign({Key? key, required this.child, required this.color})
      : super(key: key);
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: child,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            color: color,
            boxShadow: [
              BoxShadow(
                  color: TextColor(),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(1, 1)),
              BoxShadow(
                  color: BGColor(),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(-1, -1)),
            ]));
  }
}
