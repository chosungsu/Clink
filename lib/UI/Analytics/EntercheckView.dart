import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EntercheckView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    NeumorphicIcon(
                      Icons.task_alt_outlined,
                      size: 25,
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          color: Colors.black45,
                          lightSource: LightSource.topLeft),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('오늘 출석체크 이벤트 참석완료!',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
                child: Text('하루하루 잊지말고 참여하세요~',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ],
          ),
        ),
    );
  }
}
