import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:clickbyme/BACKENDPART/Getx/navibool.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
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
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: child,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: color,
                  border: Border.all(color: draw.color_textstatus, width: 1)),
            ));
  }
}

class ContainerTextFieldDesign extends StatelessWidget {
  const ContainerTextFieldDesign({
    Key? key,
    required this.searchNodeAddSection,
    required this.string,
    required this.textEditingControllerAddSheet,
  }) : super(key: key);
  final FocusNode searchNodeAddSection;
  final String string;
  final TextEditingController textEditingControllerAddSheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2)),
      child: TextField(
        focusNode: searchNodeAddSection,
        style: TextStyle(fontSize: contentTextsize(), color: Colors.black45),
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
    );
  }
}
