import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayContentHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayNoteHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/RoutineHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

class FormCard extends StatelessWidget {
  const FormCard({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            color: Colors.blue.shade400,
            child: Column(
          children: [
            SizedBox(
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    /*Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: DayContentHome()),
                    );*/
                  },
                  child: SizedBox(
                    height: 45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.blue.shade500,
                                child: const Icon(
                                  Icons.smart_toy,
                                  color: Colors.white,
                                ),
                              )
                            ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(
                          height: 45,
                          child: Center(
                            child: Text('원큐챗봇을 클릭하여 하루 기록하기',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                    overflow: TextOverflow.fade,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        )));
  }
}
