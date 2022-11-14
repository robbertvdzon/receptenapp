import 'dart:typed_data';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

import '../GetItDependencies.dart';
import '../events/ReceptChangedEvent.dart';
import '../model/recipes/v1/recept.dart';
import 'ImageTool.dart';

class ImageStorageService {
  final storageRef = FirebaseStorage.instance.ref();
  var _eventBus = getIt<EventBus>();

  Future<Image> get300x300(String uuid) {
    final image120Ref = storageRef.child(uuid + "300x300.jpg");
    Future<Uint8List?> imageFuture = image120Ref.getData();
    return imageFuture
        .then((value) => Image.memory(value!, fit: BoxFit.cover))
        .catchError((error, stackTrace) =>
            Image.asset("assets/images/transparant120x120.png"));
  }

  Future<Image> get120x120(String uuid) {
    final image120Ref = storageRef.child(uuid + "120x120.jpg");
    Future<Uint8List?> imageFuture = image120Ref.getData();
    return imageFuture
        .then((value) => Image.memory(value!, fit: BoxFit.cover))
        .catchError((error, stackTrace) =>
            Image.asset("assets/images/transparant300x300.png"));
  }

  Future<void> storeImage(Recept recept, Uint8List rawImage) async {
    final uuid = recept.uuid;
    final image120 = resizeImage2(rawImage, 120);
    final image300 = resizeImage2(rawImage, 300);
    final image120Ref = storageRef.child(uuid + "120x120.jpg");
    final image300Ref = storageRef.child(uuid + "300x300.jpg");
    await image120Ref.putData(image120);
    await image300Ref.putData(image300);
    _eventBus.fire(ReceptChangedEvent(recept));
  }
}
