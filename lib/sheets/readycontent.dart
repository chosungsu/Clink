import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';

import '../Tool/TextSize.dart';
import '../UI/Home/secondContentNet/EventShowCard.dart';

showreadycontent(
  BuildContext context,
  double height,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: readycontent(
                  context,
                  height,
                ),
              )),
        );
      }).whenComplete(() {});
}

readycontent(
  BuildContext context,
  double height,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(
                context,
                height,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('도움&문의',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

content(
  BuildContext context,
  double height,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/instagram.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('광고 및 개발문의',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                Text('DM : @dev_habittracker_official',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 15)),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: Row(
                  children: [
                    Icon(
                      Icons.forward_to_inbox,
                      size: 30,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('오류 및 건의사항',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize())),
                        Text('개발자에게 이메일보내기',
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 15)),
                      ],
                    ),
                  ],
                )),
            Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
          ],
        ),
      ],
    );
  });
}
