import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shimmer/shimmer.dart';

Shimmer_home(BuildContext context) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 5000),
    child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: MediaQuery.of(context).size.height / 3.5 * 3,
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade400
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 5.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade400
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        )),
  );
}
