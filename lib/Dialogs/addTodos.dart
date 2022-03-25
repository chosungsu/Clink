import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';

addTodos(BuildContext context, TextEditingController textEditingController,
    List<String> todolist, DateTime selectedDay) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  textEditingController.text = "";
  String time = '';
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 300,
              width: 320,
              padding: EdgeInsets.all(12),
              child: StatefulBuilder(builder: (_, StateSetter setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "일정 추가",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: textEditingController,
                      style: const TextStyle(color: Colors.black54),
                      autofocus: true,
                      decoration: const InputDecoration(
                          hintText: '일정 입력...',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 320,
                      child: NeumorphicButton(
                        onPressed: () async {
                          Future<TimeOfDay?> selectedTime = showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          selectedTime.then((timeofday) {
                            setState(() {
                              time = '${timeofday!.hour}:${timeofday.minute}';
                            });
                          });
                        },
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            depth: 2,
                            color: Colors.yellow.shade200,
                            lightSource: LightSource.topLeft),
                        child: Center(
                            child: time == ''
                                ? Text(
                                    "시간 설정",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '설정된 시간 : ' + time.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 320,
                      child: NeumorphicButton(
                        onPressed: () async {
                          //todolist.add(textEditingController.text);
                          Navigator.of(context).pop();
                          String nick = await Hive.box('user_info').get('id');
                          //firestore 저장
                          String str_snaps = '';
                          String str_todo = '';
                          await firestore
                              .collection('TODO')
                              .doc(nick + selectedDay.toString())
                              .get()
                              .then((DocumentSnapshot ds) {
                            str_snaps = (ds.data() as Map)['time'];
                            str_todo = (ds.data() as Map)['todo'];
                          });
                          str_snaps == null || str_snaps == '' ? 
                          await firestore.collection('TODO').doc(
                            nick + selectedDay.toString()
                          ).set({
                            'name': nick,
                            'date': selectedDay,
                            'time': time,
                            'todo': textEditingController.text
                          }) : 
                          await firestore
                              .collection('TODO')
                              .doc(nick + selectedDay.toString())
                              .update({
                            'time': str_snaps +
                                ',' +
                                time,
                                'todo': str_todo +
                                ',' +
                                textEditingController.text,
                          });
                        },
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            depth: 2,
                            color: Colors.teal.shade300,
                            lightSource: LightSource.topLeft),
                        child: const Center(
                            child: Text(
                          "작성 완료",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                );
              }),
            ));
      });
}
