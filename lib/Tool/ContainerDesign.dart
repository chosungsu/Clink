import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ContainerDesign extends StatelessWidget {
  const ContainerDesign({Key? key, required this.child, required this.color})
      : super(key: key);
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            lightSource: LightSource.bottom,
            intensity: 0.3,
            surfaceIntensity: 0.3,
            border: NeumorphicBorder(color: TextColor_shadowcolor(), width: 1),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
            depth: 3,
            color: color),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: child,
        ));
  }
}
