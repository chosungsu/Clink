import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/cupertino.dart';
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
    );
  }
}
