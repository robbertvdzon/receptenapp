import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'ImageTool.dart';

class ImageStorageService {
  final storageRef = FirebaseStorage.instance.ref();

  Future<Image> get300x300(String uuid) {
    final image120Ref = storageRef.child(uuid + "300x300.jpg");
    Future<Uint8List?> imageFuture = image120Ref.getData();
    return imageFuture.then((value) => Image.memory(
          value!,
          fit: BoxFit.cover,
        ));
  }

  Future<Image> get120x120(String uuid) {
    final image120Ref = storageRef.child(uuid + "120x120.jpg");
    Future<Uint8List?> imageFuture = image120Ref.getData();
    return imageFuture.then((value) => Image.memory(
          value!,
          fit: BoxFit.cover,
        ));
  }

  Future<void> storeImage(String uuid, Uint8List rawImage) async {
    final image120 = resizeImage2(rawImage, 120);
    final image300 = resizeImage2(rawImage, 300);
    final image120Ref = storageRef.child(uuid + "120x120.jpg");
    final image300Ref = storageRef.child(uuid + "300x300.jpg");
    await image120Ref.putData(image120);
    await image300Ref.putData(image300);
  }
}
