import 'dart:io';

import 'package:html/parser.dart';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';

import 'package:challenges/configuration.dart';
import 'package:challenges/challenge_base_command.dart';


class ExercismCommand extends Command {
  final name = 'exercism';
  final description = "Utils for downloading exercism commands";

  ExercismCommand() {
    addSubcommand(ExercismExtractCommand());
    addSubcommand(ExercismDownloadCommand());
  }
}

class ExercismExtractCommand extends ChallengeBaseCommand {
  final name = 'extract';
  final description =
      "Extract list of exercism exercises from exercism's listing page";

  ExercismExtractCommand() {
    argParser..addOption('html', abbr: 'f', help: 'html file to parse');
  }

  run() {
    final lang = argResults['language'];
    final htmlFile = argResults['html'];
    final config = Configuration();
    final body = File(htmlFile).readAsStringSync();

    var document = parse(body);
    var exerciseDivs = document.getElementsByClassName('widget-side-exercise');

    var exercises =
        exerciseDivs.map((div) => div.children[0].id.substring(9)).toList();
    print(exercises);
    config.writeJSONConfig('$lang/exercises.json', exercises);
  }
}

class ExercismDownloadCommand extends Command {
  final name = 'download';
  final description = "Download exercism exercises for a particular langaguage";

  run() async {
    final config = Configuration();
    final lang = argResults['language'];

    // read the exercises listed in the extract step
    List<dynamic> exercises = config.readJSONConfig('$lang/exercises.json');

    var exercismDirName = p.join(config.config['exercism']['workdir'], lang);
    final exercismDir = Directory(exercismDirName);

    // Check for already downloaded exercises
    var alreadyDownloaded = exercismDir
        .listSync(recursive: false, followLinks: false)
        .map((dir) => dir.path.split('/').last);

    // loop through the exercises and download them one by one
    for (var exercise in exercises) {
      if (!alreadyDownloaded.contains(exercise)) {
        // skip already downloade
        var result1 = await Process.run(
            'exercism', ['download', '--exercise=$exercise', '--track=dart']);
        print(result1.stdout);
        var eDir = p.join(exercismDirName, exercise);
        var result2 = await Process.run('pub', ['get'], workingDirectory: eDir);
        print(result2.stdout);
      }
    }
  }
}
