import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shimmer/shimmer.dart';

Shimmer_Chip(BuildContext context) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 3000),
    child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade400),
              )
            ],
          ),
        )),
  );
}
