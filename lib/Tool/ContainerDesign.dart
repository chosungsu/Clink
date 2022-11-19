import 'package:clickbyme/Enums/Variables.dart';
import 'package:clickbyme/Tool/Getx/navibool.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'MyTheme.dart';

class ContainerDesign extends StatelessWidget {
  const ContainerDesign({Key? key, required this.child, required this.color})
      : super(key: key);
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(10),
              child: child,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: const Offset(2, 2),
                      blurRadius: 2,
                    ),
                    BoxShadow(
                      color: draw.backgroundcolor == MyTheme.colorWhite
                          ? Colors.white
                          : Colors.black,
                      offset: const Offset(-2, -2),
                      blurRadius: 2,
                    ),
                  ]),
            ));
  }
}
