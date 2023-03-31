import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../BACKENDPART/Api/LoginApi.dart';
import '../BACKENDPART/Getx/UserInfo.dart';
import '../BACKENDPART/Getx/linkspacesetting.dart';

pickImage(source, where) async {
  final peopleadd = Get.put(UserInfo());
  final linkspaceset = Get.put(linkspacesetting());

  final image = await ImagePicker().pickImage(source: source);
  if (image == null) return;
  if (where == 'profile') {
    peopleadd.setusrimg(image.path);
    LoginApiProvider().updateTasks('img', peopleadd.usrimgurl);
  } else {
    linkspaceset.setpageimg(image.path);
  }
}
