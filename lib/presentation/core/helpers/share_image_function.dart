import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:share_plus/share_plus.dart';

Future<void> shareImageWithDescription(
    {required String imageUrl,
    required String description,
    String? subject}) async {
  final url = Uri.parse(imageUrl);
  final response = await http.get(url);
  final bytes = response.bodyBytes;

  final temp = await getTemporaryDirectory();
  final path = '${temp.path}/image.jpg';
  File(path).writeAsBytesSync(bytes);
  // ignore: deprecated_member_use
  await Share.shareFiles(
    [path],
    subject: subject,
    text: description,
    sharePositionOrigin: Rect.fromPoints(
      const Offset(2, 2),
      const Offset(3, 3),
    ),
  );
}
