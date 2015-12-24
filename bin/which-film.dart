import "dart:async";
import "dart:io";

import "package:which-film/data_search.dart";
import "package:which-film/data_service/vm.dart";


void main(List<String> args) {
  var client = new TraktVmService();
  print("Fetching watchlists ...");
  var futureWatchlists = args.map(client.watchlist);
  Future.wait(futureWatchlists)
    .then((watchlistData) {
      print("Fetching ratings ...");
      // Fastest solution would be to gather all Future calls together at once
      // and then wait for the result. It would require tagging results or
      // doing reflection to know what results were returned, though.
      var futureRatings = args.map(client.ratings);
      Future.wait(futureRatings)
        .then((ratingsData) {
          print("");
          var data = {};
          watchlistData.forEach(
            (movieSet) => updateMovies(data, movieSet, WhyChosen.watchlist));
          var moviesByRating = new Map<int, Set<Movie>>();
          ratingsData.forEach(
            (ratingsMap) => ratingsMap.forEach((m, r) {
              var movieSet = moviesByRating.putIfAbsent(r, () => new Set());
              movieSet.add(m);
            }
          ));
          updateMovies(data, moviesByRating[8], WhyChosen.rating08);
          updateMovies(data, moviesByRating[9], WhyChosen.rating09);
          updateMovies(data, moviesByRating[10], WhyChosen.rating10);
          var thisYear = (new DateTime.now()).year;
          var acceptableMovies = data.values.where(
            (m) => m.score > WhyChosen.watchlist.index && m.year <= thisYear)
            .toList();
          acceptableMovies.sort((x, y) => x.compareTo(y) * -1);
          acceptableMovies.forEach(print);
          client.close();
          exit(0);
        });
    });

}
