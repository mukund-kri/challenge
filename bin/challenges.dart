import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:challenges/create_command.dart';
import 'package:challenges/starter_command.dart';
import 'package:challenges/exercism_command.dart';


void main(List<String> args) {
  CommandRunner('challenges',
      'Utils to automate the boring tasks related to coding challenges')
    ..addCommand(CreateCommand())
    ..addCommand(StarterCommand())
    ..addCommand(ExercismCommand())
    ..run(args).catchError((error) {
      if (error is! UsageException) throw error;
      print(error);
      exit(64);
    });
}
