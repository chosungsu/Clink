import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';

class ThirdCard extends StatelessWidget {
  const ThirdCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: Column(
          children: [
            ContainerDesign(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('오늘 일정',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text('가장 가까운 일정현황',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ContainerDesign(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('운동 기록',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(
                    width: 10,
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
            ),
            SizedBox(
              height: 20,
            ),
            ContainerDesign(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('식단 밸런스',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text('아주 좋습니다',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
