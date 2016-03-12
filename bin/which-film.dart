import "dart:io";

import "package:which_film/data_search.dart";
import "package:which_film/data_service/vm.dart";
import "package:which_film/main.dart";


void main(List<String> args) {
  var client = new TraktVmService();
  void process(Iterable<ChosenMovie> movies) {
    movies.forEach((m) => print("${m} [${m.reasonsString()}]"));
    client.close();
    exit(0);
  }

  print("Fetching user data ...\n");
  driver(client, args, process);
}
