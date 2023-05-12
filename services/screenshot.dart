import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

      final repaintContext = widgetKey.currentContext;
      if (repaintContext == null) {
        return false;
      }

      RenderRepaintBoundary boundary = repaintContext.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      Uint8List rawFrame = byteData!.buffer.asUint8List();

      final fileInterceptor = await File(pathToFrame).create();
      await fileInterceptor.writeAsBytes(rawFrame);
