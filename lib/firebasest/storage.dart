import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class storage {

  final firebase_storage.FirebaseStorage frstorage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadImage(
      String filepath,
      String fileName,


      ) async{

    File file = File(filepath);
    String downoadUri;
    try{

      await frstorage.ref('files/$fileName').putFile(file);
      downoadUri = await frstorage.ref('files/$fileName').getDownloadURL();
      print(downoadUri);
      return downoadUri;
    }on firebase_storage.FirebaseException catch(e)
    {
      print(e);
      return null;
    }

  }
}