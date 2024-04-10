import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';

enum LogLevel { debug, info, warn, error, fatal }

/// 日志
class Logger {
  static const vscode = true;
  // static late MXLogger _mxLogger;
  // static late final String _logPath;
  static const key = "abcuioqbsdguijlk";
  static const iv = "bccuioqbsdguijiv";

  static Future init() async {
    // var dir = await getTemporaryDirectory();
    // _logPath = dir.path;

    // _mxLogger = await MXLogger.initialize(
    //   nameSpace: "com.financial_master.logger",
    //   storagePolicy: MXStoragePolicyType.yyyy_MM_dd,
    //   cryptKey: key,
    //   iv: iv,
    // );

    // _mxLogger.setMaxDiskAge(60 * 60 * 7);
    // _mxLogger.setMaxDiskSize(1024 * 1024 * 10);
    // _mxLogger.setFileLevel(kDebugMode ? LogLevel.debug.index : LogLevel.error.index);
  }

  static void show() async {
    if (Get.key.currentState?.overlay == null) return;

    // MXAnalyzer.showDebug(
    //   Get.key.currentState!.overlay!,
    //   cryptKey: key,
    //   iv: iv,
    //   diskcachePath: _mxLogger.diskcachePath,
    //   databasePath: _logPath,
    // );
  }

  static void close() {
    // MXAnalyzer.dismiss();
  }

  static void _outPut(String tag, String message, [LogLevel level = LogLevel.debug]) {
    // _mxLogger.log(level.index, message, tag: tag);
    if (kDebugMode) developer.log("[$tag] $message", name: DateFormat("HH:mm:ss").format(DateTime.now()));
  }

  static void getx(String log, {bool? isError}) {
    _outPut("GetX", log);
  }

  static dump(Map<String, dynamic> map) {
    _outPut("DUMP", _format(map));
  }

  static void request(RequestOptions options) {
    if (options.data == null && options.queryParameters.keys.isEmpty) {
      _outPut(options.method, "==> ${options.uri.path}\n${_formap(options.headers)}");
    } else {
      _outPut(
        options.method,
        "==> ${options.uri.path}\n${_formap(options.headers)}\n:${_format((options.data ?? options.queryParameters) ?? {})}",
      );
    }
  }

  static void response(Response response) {
    _outPut(
      response.requestOptions.method,
      '<== ${response.realUri.path}\n${_format(response.data ?? {})}',
    );
  }

  static void d(dynamic log, {String? tag, int depth = 1}) {
    if (!vscode) {
      _outPut(tag ?? "DBUG", log.toString());
    } else {
      final frame = Chain.forTrace(StackTrace.current).toTrace().frames[depth];
      final paths = frame.uri.path.split("/");
      final call = "${frame.uri.path.replaceFirst(paths[0], "./lib")}:${frame.line}:${frame.column}";
      _outPut(tag ?? "DBUG", "$log $call");
    }
  }

  static void console(dynamic log) {
    final list = log as List;
    _outPut("CONS", "[${list.first}] ${list.sublist(1).join(" ")}");
  }

  static void t(dynamic log, [int depth = 1]) {
    if (!vscode) {
      _outPut("TEST", log.toString());
    } else {
      final frames = Chain.forTrace(StackTrace.current).toTrace().frames;
      final frame = frames[depth];
      final paths = frame.uri.path.split("Financial");
      final call = ".${paths[1]}:${frame.line}:${frame.column}";
      _outPut("TEST", "$log $call");
    }
  }

  static void i(dynamic log) {
    _outPut("INFO", log.toString(), LogLevel.info);
  }

  static void w(dynamic log) {
    _outPut("WARN", log.toString(), LogLevel.warn);
  }

  static void e(dynamic log, [bool stack = true]) {
    _outPut("ERRO", log.toString(), LogLevel.error);
  }

  static String _formap(Map<String, dynamic> map) {
    var buffer = StringBuffer();
    map.forEach((key, value) {
      buffer.write("$key: $value\n");
    });
    return buffer.toString();
  }

  // 格式化输出
  static String _format(dynamic object, {int deep = 0, bool isObject = false}) {
    var buffer = StringBuffer();
    var nextDeep = deep + 1;
    if (object is Map) {
      var list = object.keys.toList();
      if (!isObject) {
        // 如果map来自某个字段，则不需要显示缩进
        buffer.write(getDeepSpace(deep));
      }
      buffer.write("{");
      if (list.isEmpty) {
        // 当map为空，直接返回‘}’
        buffer.write("}");
      } else {
        buffer.write("\n");
        for (int i = 0; i < list.length; i++) {
          buffer.write("${getDeepSpace(nextDeep)}\"${list[i]}\": ");
          buffer.write(_format(object[list[i]], deep: nextDeep, isObject: true));
          if (i < list.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
        buffer.write("\n");
        buffer.write("${getDeepSpace(deep)}}");
      }
    } else if (object is List) {
      if (!isObject) {
        // 如果list来自某个字段，则不需要显示缩进
        buffer.write(getDeepSpace(deep));
      }
      buffer.write("[");
      if (object.isEmpty) {
        // 当list为空，直接返回‘]’
        buffer.write("]");
      } else {
        buffer.write("\n");
        for (int i = 0; i < object.length; i++) {
          buffer.write(_format(object[i], deep: nextDeep));
          if (i < object.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
        buffer.write("\n");
        buffer.write("${getDeepSpace(deep)}]");
      }
    } else if (object is String) {
      // 为字符串时，需要添加双引号并返回当前内容
      buffer.write("\"$object\"");
    } else if (object is num || object is bool) {
      // 为数字或者布尔值时，返回当前内容
      buffer.write(object);
    } else {
      // 如果对象为空，则返回null字符串
      buffer.write("null");
    }
    return buffer.toString();
  }

  static String getDeepSpace(int deep) {
    var tab = StringBuffer();
    for (int i = 0; i < deep; i++) {
      tab.write("  ");
    }
    return tab.toString();
  }
}
