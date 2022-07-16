import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReportView extends StatelessWidget {
  final List routineday = ['일', '월', '화', '수', '목', '금', '토'];
  final List routinesucceed = [20, 20, 80, 60, 60, 80, 100];
  final List personwith = [
    '김영헌',
    '이제민',
    '최우성',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width - 40,
      child: Box(context)
    );
  }
  Box(BuildContext context) {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            color: Colors.white,
            child: Hive.box('user_setting').get('numorimogi_routine') == null
                ? ListView.builder(
                    // the number of items in the list
                    itemCount: routineday.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // display each item of the product list
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) / 7,
                        child: Column(
                          children: [
                            Text(routineday[index],
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(routinesucceed[index].toString() + '%',
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15))
                          ],
                        ),
                      );
                    })
                : (Hive.box('user_setting').get('numorimogi_routine') == 0
                    ? ListView.builder(
                        // the number of items in the list
                        itemCount: routineday.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        // display each item of the product list
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 7,
                            child: Column(
                              children: [
                                Text(routineday[index],
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(routinesucceed[index].toString() + '%',
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))
                              ],
                            ),
                          );
                        })
                    : ListView.builder(
                        // the number of items in the list
                        itemCount: routineday.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        // display each item of the product list
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 7,
                            child: Column(
                              children: [
                                Text(routineday[index],
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1,
                                            style: BorderStyle.solid)),
                                    child: routinesucceed[index] < 35
                                        ? Text(
                                            personwith[0]
                                                .toString()
                                                .substring(0, 1),
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))
                                        : (routinesucceed[index] < 70
                                            ? Text(
                                                personwith[1]
                                                    .toString()
                                                    .substring(0, 1),
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15))
                                            : Text(
                                                personwith[2]
                                                    .toString()
                                                    .substring(0, 1),
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15))))
                              ],
                            ),
                          );
                        }))),
      );
    });
  }
}
