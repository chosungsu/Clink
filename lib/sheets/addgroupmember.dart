import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';

addgroupmember(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            searchNode.unfocus();
          },
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 440,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: SheetPage(
                        context, searchNode, controller),),
          ),
        );
      });
}

SheetPage(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
) {
  final List<String> list_user = <String>[];
  return SizedBox(
      height: 420,
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) * 0.4,
                      ),
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) * 0.4,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context, controller),
              const SizedBox(
                height: 20,
              ),
              content(
                  context, searchNode, list_user, controller,)
            ],
          )));
}

title(
  BuildContext context,
  TextEditingController controller,
) {
  return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Flexible(
            fit: FlexFit.tight,
            child: Text('피플',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
          ),
          TextButton(
              onPressed: () {
                controller.clear();
                Hive.box('user_setting').put('user_people', null);
                Navigator.pop(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('창 닫기',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ],
              ))
        ],
      ));
}

content(
  BuildContext context,
  FocusNode searchNode,
  List<String> list_user,
  TextEditingController controller,
) {
  String name = Hive.box('user_info').get('id').toString().length > 5
      ? Hive.box('user_info').get('id').toString().substring(0, 4)
      : Hive.box('user_info').get('id').toString().substring(0, 2);
  String email_first =
      Hive.box('user_info').get('email').toString().substring(0, 3);
  String email_second = Hive.box('user_info')
      .get('email')
      .toString()
      .split('@')[1]
      .substring(0, 2);
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text('고유 Code',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize())),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SelectableText(email_first + email_second + name,
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize())),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text('피플 추가하기',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  /*TextButton(
                    onPressed: () {
                      searchNode.unfocus();
                    },
                    child: Text('검색',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  )*/
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SearchBox(
                searchNode, list_user, controller, context,)
          ],
        ));
  });
}

SearchBox(
    FocusNode searchNode,
    List<String> list_user,
    TextEditingController controller,
    BuildContext context,) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return SizedBox(
    height: 140,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        usersearch(list_user, firestore, controller, searchNode, context,
            )
      ],
    ),
  );
}

Search(
    FocusNode searchNode,
    List<String> list_user,
    TextEditingController controller,
    FirebaseFirestore firestore,
    BuildContext context,) {
  String username = Hive.box('user_info').get(
    'id',
  );
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Hive.box('user_setting').get(
                'user_people',
              ) ==
              null
          ? SizedBox(
              height: 50,
              child: ContainerDesign(
                  child: TextField(
                    controller: controller,
                    focusNode: searchNode,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintMaxLines: 2,
                        hintText: '검색방법 : #친구의 고유 Code',
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black45),
                        prefixIcon: IconButton(
                          onPressed: () {
                            searchNode.unfocus();
                            usersearch(list_user, firestore, controller,
                                searchNode, context,);
                          },
                          icon: const Icon(Icons.search),
                        ),
                        isCollapsed: true,
                        prefixIconColor: Colors.black),
                  ),
                  color: Colors.white))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 50,
                    child: ContainerDesign(
                        child: TextField(
                          controller: controller,
                          focusNode: searchNode,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintMaxLines: 2,
                              hintText: '검색방법 : #친구의 고유 Code',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black45),
                              prefixIcon: IconButton(
                                onPressed: () {
                                  searchNode.unfocus();
                                  controller.text.isNotEmpty
                                      ? usersearch(
                                          list_user,
                                          firestore,
                                          controller,
                                          searchNode,
                                          context,)
                                      : null;
                                },
                                icon: const Icon(Icons.search),
                              ),
                              isCollapsed: true,
                              prefixIconColor: Colors.black),
                        ),
                        color: Colors.white)),
                SizedBox(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 70,
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: list_user.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ContainerDesign(
                                            color: Colors.white,
                                            child: SizedBox(
                                              height: 30,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                        list_user[index] +
                                                            '(이)가 맞습니까?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize())),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 25,
                                                      height: 25,
                                                      child: InkWell(
                                                        onTap: () {
                                                          firestore
                                                              .collection(
                                                                  'PeopleList')
                                                              .doc(username)
                                                              .set(
                                                                  {
                                                                'people':
                                                                    list_user[
                                                                        index]
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));

                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Container(
                                                                height: 90,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: Colors
                                                                        .blueGrey),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                        'Notice',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 23)),
                                                                    Flexible(
                                                                        fit: FlexFit
                                                                            .tight,
                                                                        child: Text(
                                                                            '정상적으로 추가되었습니다.',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20)))
                                                                  ],
                                                                )),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0,
                                                          ));
                                                        },
                                                        child: NeumorphicIcon(
                                                          Icons.add,
                                                          size: 20,
                                                          style: const NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              color: Colors
                                                                  .black45,
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ));
                              }),
                        )
                      ],
                    ))
              ],
            )
    ],
  );
}

usersearch(
    List<String> list_user,
    FirebaseFirestore firestore,
    TextEditingController controller,
    FocusNode searchNode,
    BuildContext context,) {
  return controller.text.isEmpty
      ? Search(searchNode, list_user, controller, firestore, context,)
      : FutureBuilder(
          future: firestore
              .collection("User")
              .where('code', isEqualTo: controller.text.split('#')[1])
              .get()
              .then(((QuerySnapshot querySnapshot) => {
                    list_user.clear(),
                    querySnapshot.docs.forEach((doc) {
                      list_user.add(doc.get('name'));
                    }),
                    Hive.box('user_setting').put('user_people', list_user),
                  })),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Search(searchNode, list_user, controller, firestore,
                  context,);
            } else {
              return Search(searchNode, list_user, controller, firestore,
                  context,);
            }
          });
}
