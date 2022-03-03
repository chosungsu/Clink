import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class Additional extends StatefulWidget {
  final String value;
  const Additional({Key? key, required this.value}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdditionalState();
}

class _AdditionalState extends State<Additional> {
  List<Asset> images = <Asset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return checkavail();
            }
            else {
              images = snapshot.data as List<Asset>;
              return GridView.count(
                crossAxisCount: 3,
                children: List.generate(images.length, (index) {
                  Asset asset = images[index];
                  return AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  );
                }),
              );
            }
          },
          future: choiceAdditional(context, widget.value),
        )
      ),
    );
  }

  choiceAdditional
      (BuildContext context, String value) async {
    List<Asset> resultList = <Asset>[];
    if (value == '1') {
    } else {
      try {
        resultList = await MultiImagePicker
            .pickImages(
            maxImages: 300,
            enableCamera: true,
            selectedAssets: images,
            materialOptions: MaterialOptions(
                actionBarTitle: "Pick"
            )
        );
      } on Exception catch(e) {
        print(e);
      }
      setState(() {
        images = resultList;
      });
      return images;
    }
  }
  checkavail() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Text(
              "경고",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: new Text(
              "이용자분의 현재 단말기에서는 "
                  "사용불가한 기능입니다.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
}
