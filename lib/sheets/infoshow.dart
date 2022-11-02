import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';

infoshow(
    int index,
    String doc_date,
    String doc_editdate,
    String doc_name,
    BuildContext context,
    String doc_made_user,
    String collection,
    String isfromwhere) {
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
                child: infos(context, doc_date, doc_editdate, doc_made_user,
                    doc_name, collection, isfromwhere),
              )),
        );
      }).whenComplete(() {});
}

infos(
  BuildContext context,
  String doc_date,
  String doc_editdate,
  String doc_made_user,
  String doc_name,
  String collection,
  String isfromwhere,
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
              contents(context, doc_date, doc_editdate, doc_made_user, doc_name,
                  collection, isfromwhere),
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

contents(
  BuildContext context,
  String doc_date,
  String doc_editdate,
  String doc_made_user,
  String doc_name,
  String collection,
  String isfromwhere,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        isfromwhere == 'link'
            ? const SizedBox(
                height: 0,
              )
            : Row(
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
        isfromwhere == 'link'
            ? const SizedBox(
                height: 0,
              )
            : const SizedBox(
                height: 20,
              ),
        isfromwhere == 'memo'
            ? Row(
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
              )
            : const SizedBox(
                height: 0,
              ),
        isfromwhere == 'memo'
            ? const SizedBox(
                height: 20,
              )
            : const SizedBox(
                height: 0,
              ),
        isfromwhere == 'memo'
            ? Row(
                children: [
                  const Icon(
                    Icons.label,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(collection.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        isfromwhere == 'memo'
            ? const SizedBox(
                height: 20,
              )
            : const SizedBox(
                height: 0,
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
