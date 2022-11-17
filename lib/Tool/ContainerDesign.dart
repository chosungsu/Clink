import 'package:clickbyme/Tool/Getx/navibool.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

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
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-2, -2),
                      blurRadius: 2,
                    ),
                  ]),
            ));
  }
}
