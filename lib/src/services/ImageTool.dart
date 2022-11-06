import 'package:image/image.dart';
import 'dart:convert';
import 'dart:typed_data';

String resizeImage(String base64Image, int size) {
  Image image = decodeImage(base64Decode(base64Image))!;
  Image resizeImage = copyResizeCropSquare(image, size);
  return base64Encode(Uint8List.fromList(encodePng(resizeImage)));
}
