import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';

calendarinfo(int index, String id, String doc_date, String doc_name,
    BuildContext context, String doc_made_user) {
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
                child: infocal(context, doc_date, doc_made_user, doc_name),
              )),
        );
      }).whenComplete(() {});
}

memoinfo(
    int index,
    String id,
    String doc_date,
    String doc_editdate,
    String doc_name,
    BuildContext context,
    String doc_made_user,
    String doc_collection) {
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
                child: infomemo(context, doc_date, doc_made_user, doc_name,
                    doc_editdate, doc_collection),
              )),
        );
      }).whenComplete(() {});
}

infocal(
  BuildContext context,
  String doc_date,
  String doc_made_user,
  String doc_name,
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
              title(context, doc_name),
              const SizedBox(
                height: 30,
              ),
              contentcal(context, doc_date, doc_made_user, doc_name),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

infomemo(
  BuildContext context,
  String doc_date,
  String doc_made_user,
  String doc_name,
  String doc_editdate,
  String doc_collection,
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
              title(context, doc_name),
              const SizedBox(
                height: 30,
              ),
              contentmemo(context, doc_date, doc_made_user, doc_name,
                  doc_editdate, doc_collection),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
  String doc_name,
) {
  return SizedBox(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        doc_name.toString(),
        maxLines: 2,
        softWrap: true,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: contentTitleTextsize()),
        overflow: TextOverflow.clip,
      )
    ],
  ));
}

contentcal(
  BuildContext context,
  String doc_date,
  String doc_made_user,
  String doc_name,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.schedule,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(doc_date.toString(),
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Icon(
              Icons.portrait,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(doc_made_user.toString(),
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ],
        ),
      ],
    );
  });
}

contentmemo(
  BuildContext context,
  String doc_date,
  String doc_made_user,
  String doc_name,
  String doc_editdate,
  String doc_collection,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.history,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(doc_date.toString(),
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Icon(
              Icons.update,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(doc_editdate.toString(),
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Icon(
              Icons.label,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(doc_collection.toString(),
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Icon(
              Icons.portrait,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(doc_made_user.toString(),
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ],
        ),
      ],
    );
  });
}
