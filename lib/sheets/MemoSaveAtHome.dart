import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Tool/BGColor.dart';
import '../Tool/TextSize.dart';

MemoSave(
  BuildContext context,
  doc_id,
  doc_tag,
  doc_color,
  doc_title,
  doc_made_user,
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
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    child: SheetPageMemoSave(
                      context,
                      doc_id,
                      doc_tag,
                      doc_color,
                      doc_title,
                      doc_made_user,
                    ),
                  )),
            ));
      }).whenComplete(() {});
}

SheetPageMemoSave(
  BuildContext context,
  doc_id,
  doc_tag,
  doc_color,
  doc_title,
  doc_made_user,
) {
  return SizedBox(
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  width: MediaQuery.of(context).size.width - 70,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 70) * 0.4,
                      ),
                      Container(
                          width: (MediaQuery.of(context).size.width - 70) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 70) * 0.4,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              content(
                context,
                doc_id,
                doc_tag,
                doc_color,
                doc_title,
                doc_made_user,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

content(BuildContext context, doc_id, doc_tag, doc_color, doc_title,
    doc_made_user) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('MemoDataBase')
                .where('OriginalUser', isEqualTo: doc_made_user)
                .where('Collection', isEqualTo: doc_tag)
                .where('color', isEqualTo: doc_color)
                .where('memoTitle', isEqualTo: doc_title)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  onTap: () {
                    print('yes');
                    setState(() {
                      snapshot.data!.docs[0]['homesave'] == false
                          ? firestore
                              .collection('MemoDataBase')
                              .doc(doc_id)
                              .update({
                              'homesave': true,
                            })
                          : firestore
                              .collection('MemoDataBase')
                              .doc(doc_id)
                              .update({
                              'homesave': false,
                            });
                    });
                  },
                  horizontalTitleGap: 10,
                  dense: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        snapshot.data!.docs[0]['homesave'] == false
                            ? Icons.launch
                            : Icons.block,
                        color: snapshot.data!.docs[0]['homesave'] == false
                            ? Colors.blue.shade400
                            : Colors.red.shade400,
                      ),
                    ],
                  ),
                  title: Text(
                      snapshot.data!.docs[0]['homesave'] == false
                          ? '홈화면으로 내보내기'
                          : '홈화면으로 내보내기 중단',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                );
              }
              return ListTile(
                onTap: () {
                  print('not');
                  setState(() {
                    firestore.collection('MemoDataBase').doc(doc_id).update({
                      'homesave': true,
                    });
                  });
                },
                horizontalTitleGap: 10,
                dense: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.launch,
                      color: Colors.blue.shade400,
                    ),
                  ],
                ),
                title: Text('홈화면으로 내보내기',
                    style: TextStyle(
                        color: TextColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              );
            })
      ],
    ));
  });
}
