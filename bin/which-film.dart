import "dart:io";

import 'package:logging/logging.dart';

import "package:which_film/data_search.dart";
import "package:which_film/data_service/vm.dart";
import "package:which_film/main.dart";

void main(List<String> args) {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.message}');
  });

  var client = new TraktVmService();
  void process(Iterable<ChosenMovie> movies) {
    print("");
    movies.forEach((m) => print("${m} [${m.reasonsString()}]"));
    client.close();
    exit(0);
  }

  Logger.root.info("Fetching user data");

  driver(client, args, process);
}
