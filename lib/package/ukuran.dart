import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Ukuran {
  /// Mengembalikan ukuran pixel layar (width x height)
  static String getLogicalPixelInfo(BuildContext context) {
    final Size logicalSize = MediaQuery.of(context).size;
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final double width = logicalSize.width * devicePixelRatio;
    final double height = logicalSize.height * devicePixelRatio;
    return '${width.toStringAsFixed(0)} x ${height.toStringAsFixed(0)} Pixel';
  }

  /// Mengembalikan ukuran file dalam MB
  static double getImageSizeMB(File imageFile) {
    int imageSize = imageFile.lengthSync();
    double imageMB = imageSize / (1024 * 1024);
    return imageMB;
  }

  /// Mengembalikan teks ukuran gambar yang sudah diformat
  static String formatImageSizeMB(File imageFile) {
    final mb = getImageSizeMB(imageFile);
    if (mb < 1) {
      return '${(mb * 1024).toStringAsFixed(2)} KB';
    } else {
      return '${mb.toStringAsFixed(2)} MB';
    }
  }

  /// 🔹 Mengembalikan ukuran pixel dari file gambar (misalnya 1080 x 720)
  static Future<String> getImagePixelSize(File imageFile) async {
    final completer = Completer<String>();
    final image = Image.file(imageFile);

    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            final ui.Image img = info.image;
            completer.complete('${img.width} x ${img.height} Pixel');
          }),
        );

    return completer.future;
  }
}
