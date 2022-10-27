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
        color: Colors.orange.shade400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width - 80,
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Colors.orange.shade500,
                            child: const Icon(
                              Icons.task_alt_outlined,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      height: 30,
                      child: Center(
                        child: Text(
                          '오늘 출석체크 이벤트 참석완료!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width - 80,
              child: const Text(
                '하루하루 잊지말고 참여하세요~',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
