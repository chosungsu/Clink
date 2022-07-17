import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

ADEvents(BuildContext context) {
    return ContainerDesign(
        child: SizedBox(
          height: 30,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                '광고공간입니다',
                style: MyTheme.bodyTextMessage,
              ),
            ],
          ),
        ),
        color: Colors.yellow);
  }