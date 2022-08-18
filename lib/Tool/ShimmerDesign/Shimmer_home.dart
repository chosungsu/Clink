import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shimmer/shimmer.dart';

import '../BGColor.dart';
import '../ContainerDesign.dart';
import '../MyTheme.dart';

Shimmer_home(BuildContext context) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 2000),
    child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  children: [
                    ContainerDesign(
                      color: BGColor(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Shimmer.fromColors(
                              child: Container(
                                width: 50,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey,
                                ),
                              ),
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100),
                          const SizedBox(height: 5),
                          Shimmer.fromColors(
                              child: Container(
                                width: double.infinity,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey,
                                ),
                              ),
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ));
        }),
  );
}
