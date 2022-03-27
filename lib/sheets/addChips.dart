import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

addChips(BuildContext context, TextEditingController eventController) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "어떤 태그를 추가하시겠습니까?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: eventController,
                  decoration:
                      const InputDecoration(hintText: "여기에 추가하실 태그를 작성해주세요."),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text("작성 취소"),
                      onPressed: () {
                        eventController.clear();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("작성 완료"),
                      onPressed: () async {
                        if (eventController.text.isEmpty) {
                          eventController.clear();
                          Navigator.pop(context);
                        } else {
                          
                          //firestore 저장
                          String nick = await Hive.box('user_info').get('id');
                          String str_first_word = '';
                          String str_title = '';
                          await firestore
                              .collection('CHIP')
                              .doc(Hive.box('user_info').get('id'))
                              .get()
                              .then((DocumentSnapshot ds) {
                            if (ds.data() != null) {
                              str_first_word = (ds.data() as Map)['first_word'];
                              str_title = (ds.data() as Map)['title'];
                              str_title != '' ?
                              firestore
                                  .collection('CHIP')
                                  .doc(nick)
                                  .update({
                                'first_word': str_first_word + ',' 
                                + eventController.text.substring(0, 1),
                                'title':
                                    str_title + ',' + eventController.text,
                              }) :
                              firestore
                                  .collection('CHIP')
                                  .doc(nick)
                                  .update({
                                'first_word': eventController.text.substring(0, 1),
                                'title': eventController.text,
                              });
                            } else {
                              firestore
                                  .collection('CHIP')
                                  .doc(nick)
                                  .set({
                                'first_word': eventController.text.substring(0, 1),
                                'title': eventController.text,
                              });
                            }
                          });
                          eventController.clear();
                          Navigator.pop(context);
                          
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
