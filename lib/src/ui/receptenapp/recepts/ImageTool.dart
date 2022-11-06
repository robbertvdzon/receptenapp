import 'package:image/image.dart';
import 'dart:convert';
import 'dart:typed_data';

String resizeImage(String base64Image) {
  Image image = decodeImage(base64Decode(base64Image))!;
  Image resizeImage = copyResizeCropSquare(image, 80);
  return base64Encode(Uint8List.fromList(encodePng(resizeImage)));
}
