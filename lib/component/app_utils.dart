import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as im;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../enum/user_state.dart';

class AppUtils{
  static String getUsername(String email){
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String? name, String replacement) {
    if(name == null || name.isEmpty){
      return replacement.substring(0,2).toUpperCase();
    }
    List<String> nameSplit = name.split(" ");
    if(nameSplit.length >1){
      String firstNameInitial = nameSplit[0][0];
      String lastNameInitial = nameSplit[1][0];
      return firstNameInitial + lastNameInitial;
    }
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[0][1];
    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    File selectedImage = File((await picker.pickImage(source: source))!.path);
    return await compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    im.Image? image = im.decodeImage(imageToCompress.readAsBytesSync());
    im.copyResize(image!, width: 500, height: 500);

    return File('$path/img_$rand.jpg')
      ..writeAsBytesSync(im.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int? number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }
}