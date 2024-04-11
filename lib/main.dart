import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app.dart';
import '/utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.log = Logger.getx;
  registerErrorHandler();

  if (Platform.isAndroid) {
    // android system bar
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  runApp(const MainApp());
}

registerErrorHandler() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Logger.e(details);
  };

  PlatformDispatcher.instance.onError = (err, stack) {
    Logger.e('$err\n$stack');
    return true;
  };

  ErrorWidget.builder = (detials) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text('An error occurred\n${detials.toString()}'),
      ),
    );
  };
}
