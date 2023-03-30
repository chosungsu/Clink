import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../BACKENDPART/Api/LoginApi.dart';
import '../BACKENDPART/Getx/UserInfo.dart';

pickImage(source) async {
  final peopleadd = Get.put(UserInfo());
  final image = await ImagePicker().pickImage(source: source);
  if (image == null) return;
  peopleadd.setusrimg(image.path);
  LoginApiProvider().updateTasks('img', peopleadd.usrimgurl);
}
