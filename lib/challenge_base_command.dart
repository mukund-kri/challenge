import 'package:args/command_runner.dart';

/// Base Class for all Commands for the 'challenges' utility
///
/// Handles the language command line option, which is universal accross
/// all commands.
abstract class ChallengeBaseCommand extends Command {
  ChallengeBaseCommand() {
    argParser
      ..addOption('language',
          abbr: 'l', help: 'Choose which language challenge to work on');
  }
}
