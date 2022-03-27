import 'package:flutter/material.dart';

Widget Chips(String label, String avatar, Color color, bool isselected,
    TextEditingController eventController) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Container(
      margin: EdgeInsets.all(10),
      child: InputChip(
        labelPadding: EdgeInsets.all(10),
        avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Text(
              avatar,
              style: TextStyle(color: Colors.black),
            )),
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        elevation: 5,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(6),
        selected: isselected,
        selectedColor: Colors.red,
        onSelected: (bool selected) {
          setState(() {
            isselected = selected;
          });
        },
      ),
    );
  });
}
