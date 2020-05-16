import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:yaml/yaml.dart';
import 'package:args/command_runner.dart';

/// Command Class to create the coding challenge day folder based on
/// today s date
class CreateCommand extends Command {
  final name = 'create';
  final description = "Create the directories for today's coding challenge";

  CreateCommand() {
    argParser
      ..addFlag('exercism',
          abbr: 'e', defaultsTo: true, help: 'generate exercism folder')
      ..addFlag('lib',
          abbr: 'd',
          defaultsTo: true,
          help: 'generate libs-exploration flolder')
      ..addOption('language',
          abbr: 'l', help: 'Choose which language challenge to work on');
  }

  void run() {
    var home = Platform.environment['HOME'];

    // Read config file
    var configFile = p.join(home, '.config/utils', 'code_challenge.yaml');
    var config = loadYaml(File(configFile).readAsStringSync());

    // extract out the repo dir from config file
    var language = argResults['language'];
    var challengeRepoDir = config['daygen'][language]['dir'];

    // directory name is today's date
    var date = DateFormat('yyyy.MM.dd').format(DateTime.now());

    var codeDir = p.join(home, challengeRepoDir, date);
    Directory(codeDir).createSync(recursive: true);
    File(p.join(codeDir, 'README.md')).createSync();

    // if the exercism flag is turned on then create the exercism
    // subdirectory
    if (argResults['exercism']) {
      Directory(p.join(codeDir, 'exercism')).createSync(recursive: true);
    }

    // if the lib flag is turned on then create the libs-exploration folder
    if (argResults['lib']) {
      Directory(p.join(codeDir, 'libs-exploration'))
          .createSync(recursive: true);
    }
  }
}
