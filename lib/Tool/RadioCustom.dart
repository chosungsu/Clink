import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget trailing;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    required this.trailing,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          ContainerDesign(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Text(
                      leading,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: groupValue == value
                              ? Colors.white
                              : Colors.black),
                    ),
                  )),
              color: groupValue == value ? Colors.blue : Colors.white),
          const SizedBox(width: 10),
          if (title != null) title,
          trailing,
        ],
      ),
    );
  }
}
