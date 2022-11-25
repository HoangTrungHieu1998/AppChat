import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:skype_clone/resources/chat_methods.dart';

import '../logic/image_provider.dart';

class StorageMethods{
  late Reference _storageReference;

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask storageUploadTask = _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return "";
    }
  }

  void uploadImage({
    required File image,
    required String receiverId,
    required String senderId,
    required ImageUploadProvider imageUploadProvider
  }) async {

    final ChatMethods chatMethods = ChatMethods();
    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }
}