library jsonata_flutter;

import 'package:flutter_js/flutter_js.dart';
import 'package:jsonata_flutter/jsonata.min.dart';

/// A class to execute JSONata expressions on JSON data in Flutter.
class JsonAta {
  late JavascriptRuntime _flutterJs;
  String? jsonData;
  bool _isLibraryLoaded = false;

  /// Creates a new instance of JsonAta.
  ///
  /// [jsonData] is optional and can be provided later in the [execute] method.
  JsonAta({this.jsonData}) {
    _flutterJs = getJavascriptRuntime(forceJavascriptCoreOnAndroid: true);
  }

  /// Loads the JSONata library if it hasn't been loaded yet.
  Future<void> _loadJsonataLib() async {
    if (_isLibraryLoaded) return;

    try {
      String jsonata = jsonAtaMinJS;
      _flutterJs.evaluate(jsonata);
      _isLibraryLoaded = true;
    } catch (e) {
      throw Exception('Failed to load JSONata library: $e');
    }
  }

  /// Executes a JSONata expression on the provided JSON data.
  ///
  /// [expression] is the JSONata expression to execute.
  /// [jsonData] is optional if it was provided in the constructor.
  Future<dynamic> execute(
      {required String expression, String? jsonData}) async {
    await _loadJsonataLib();

    final data = jsonData ?? this.jsonData;
    if (data == null) {
      throw ArgumentError(
          'JSON data must be provided either in the constructor or in the execute method.');
    }

    try {
      String jsCode = '''
        (async function() {
          var data = $data;
          var expression = jsonata('$expression');
          var result = await expression.evaluate(data);
          return JSON.stringify(result);
        })();
      ''';
      JsEvalResult jsResult = await _flutterJs.evaluateAsync(jsCode);
      _flutterJs.executePendingJob();
      final promiseResolved = await _flutterJs.handlePromise(jsResult);
      return promiseResolved.stringResult;
    } catch (e) {
      throw Exception('Error executing JSONata expression: $e');
    }
  }
}
