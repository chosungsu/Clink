// ignore_for_file: camel_case_types

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, required this.wherein}) : super(key: key);
  final String wherein;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ModalBarrier(
          color: BGColor(),
          dismissible: false,
        ),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Colors.blueGrey.shade100
                        : Colors.blueAccent.shade400,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            wherein == 'cal' || wherein == 'caleach'
                ? SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: const Center(
                      child: Text('일정표 끄적이는중...',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blueAccent,
                          ),
                          overflow: TextOverflow.clip),
                    ),
                  )
                : (wherein == 'login'
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: const Center(
                          child: Text('로그인중입니다...',
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueAccent,
                              ),
                              overflow: TextOverflow.clip),
                        ),
                      )
                    : (wherein == 'route'
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: const Center(
                              child: Text('페이지 이동중이에요~',
                                  maxLines: 2,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                  ),
                                  overflow: TextOverflow.clip),
                            ),
                          )
                        : (wherein == 'noteeach'
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: const Center(
                                  child: Text('당신의 메모를 편집하는중...',
                                      maxLines: 2,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                      ),
                                      overflow: TextOverflow.clip),
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: const Center(
                                  child: Text('업로드 준비중입니다...',
                                      maxLines: 2,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                      ),
                                      overflow: TextOverflow.clip),
                                ),
                              ))))
          ],
        )),
      ],
    );
  }
}

class Loader_sheets extends StatelessWidget {
  const Loader_sheets({Key? key, required this.wherein, required this.height})
      : super(key: key);
  final String wherein;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      child: Stack(
        children: <Widget>[
          ModalBarrier(
            color: BGColor(),
            dismissible: false,
          ),
          Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitWave(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? Colors.blueGrey.shade100
                          : Colors.blueAccent.shade400,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              wherein == 'cal' || wherein == 'caleach'
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: const Center(
                        child: Text('일정표 끄적이는중...',
                            maxLines: 2,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blueAccent,
                            ),
                            overflow: TextOverflow.clip),
                      ),
                    )
                  : (wherein == 'login'
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: const Center(
                            child: Text('로그인중입니다...',
                                maxLines: 2,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                ),
                                overflow: TextOverflow.clip),
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: const Center(
                            child: Text('당신의 메모를 편집하는중...',
                                maxLines: 2,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                ),
                                overflow: TextOverflow.clip),
                          ),
                        ))
            ],
          )),
        ],
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const <Widget>[
        ModalBarrier(
          color: Colors.black45,
          dismissible: true,
        ),
      ],
    );
  }
}
