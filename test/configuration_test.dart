import 'package:day_code_gen/configuration.dart';
import 'package:test/test.dart';


void main() {

  group('Configuration', () {

    var config = Configuration();

    test('Writing a json config should', () {
      var langs = ['Dart', 'Kotlin', 'Scala'];

      config.writeJSONConfig('dart/list.json', langs);
    });
  });
}