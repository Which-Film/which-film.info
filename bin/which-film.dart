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
      print("");
      var data = {};
      movieData.forEach(
        (movieSet) => updateMovies(data, movieSet, WhyChosen.watchlist));
      var acceptableMovies = data.values.where(
        (m) => m.score > WhyChosen.watchlist.index).toList();
      acceptableMovies.sort((x, y) => x.compareTo(y) * -1);
      for (var match in acceptableMovies) {
        print(match);
      }
      client.close();
      exit(0);
    });

}
