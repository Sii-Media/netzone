import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'package:share_plus/share_plus.dart';

Future<void> shareImageWithDescription(
    {required String imageUrl, required String description}) async {
  final url = Uri.parse(imageUrl);
  final response = await http.get(url);
  final bytes = response.bodyBytes;

  final temp = await getTemporaryDirectory();
  final path = '${temp.path}/image.jpg';
  File(path).writeAsBytesSync(bytes);
  // ignore: deprecated_member_use
  await Share.shareFiles([path], text: description);
}
