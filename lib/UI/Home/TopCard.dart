import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  const TopCard({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: ContainerDesign(
            child: SizedBox(
          height: height * 0.13,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: height * 0.05,
                child: Text('당신의 일상루틴을 새롭게 시작해보세요',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.03,
                child: Text('BOnd는 개인화 데이라이프 플랫폼입니다.',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ],
          ),
        )));
  }
}
