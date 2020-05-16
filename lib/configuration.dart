
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

class Configuration {

  String _homeDir;
  String _configDir = '.config/utils';
  YamlMap _config;

  // Make this class a singleton
  static final Configuration _instance = Configuration._init();

  factory Configuration() {
    return _instance;
  }

  Configuration._init() {
    // Geth the home dir from the environment
    _homeDir = Platform.environment['HOME'];
  }

  String get configDir => _configDir;
  set configDir (dir) => this._configDir = dir;

  YamlMap get config {
    if (_config == null) {
      var configPath = p.join(_homeDir, _configDir, 'code_challenge.yaml');
      _config = loadYaml(File(configPath).readAsStringSync());
    }
    return _config;
  }

  /// Write a specific configuration as seperate json file
  void writeJSONConfig(String relativePath, Object content) {
    var jsonFilePath = p.join(_homeDir, _configDir, relativePath);
    var jsonContent = jsonEncode(content);

    File(jsonFilePath)
      ..createSync(recursive: true)
      ..writeAsStringSync(jsonContent); 
  }

  /// Read a specific configuration json file
  dynamic readJSONConfig(String relativePath) {
    var jsonFilePath = p.join(_homeDir, _configDir, relativePath);
    return json.decode(File(jsonFilePath).readAsStringSync());
  }
}