import 'package:clickbyme/Enums/Variables.dart';
import 'package:clickbyme/Tool/Getx/navibool.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'MyTheme.dart';
import 'TextSize.dart';

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

class ContainerTextFieldDesign extends StatelessWidget {
  const ContainerTextFieldDesign(
      {Key? key,
      required this.searchNodeAddSection,
      required this.string,
      required this.textEditingControllerAddSheet})
      : super(key: key);
  final FocusNode searchNodeAddSection;
  final String string;
  final TextEditingController textEditingControllerAddSheet;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
      builder: (_) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: draw.backgroundcolor, width: 2)),
        child: TextField(
          focusNode: searchNodeAddSection,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10),
            border: InputBorder.none,
            isCollapsed: true,
            hintText: string,
            hintStyle:
                TextStyle(fontSize: contentTextsize(), color: Colors.black45),
          ),
          controller: textEditingControllerAddSheet,
        ),
      ),
    );
  }
}
