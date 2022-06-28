import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';

class ThirdCard extends StatelessWidget {
  const ThirdCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ContainerDesign(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('오늘 일정',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text('00:00 \n가장 가까운 일정현황',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  )
                ],
              ),
            )),
            ContainerDesign(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('운동 기록',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text('운동 시각',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  )
                ],
              ),
            )),
          ],
        ));
  }
}
