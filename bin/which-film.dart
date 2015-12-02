import "dart:async";
import "dart:io";

import "package:which-film/data_search.dart";
import "package:which-film/data_service/vm.dart";


void main(List<String> args) {
  var client = new TraktVmService();
  print("Fetching watchlists ...");
  var futureMovies = args.map(client.watchlist);
  Future.wait(futureMovies)
    .then((movieData) {
      var data = {};
      for (var i = 0; i < args.length; i++) {
        data[args[i]] = movieData[i];
      }
      for (var username in data.keys) {
        print("${username} has ${data[username].length} movies");
      }
      print("");

      print("Finding matches ...");
      for (var match in findMovies(data)) {
        print(match);
      }
      client.close();
      exit(0);
    });

}
