import "dart:async";
import "dart:io";

import "package:which-film/data_search.dart";
import "package:which-film/data_service/common.dart";
import "package:which-film/data_service/vm.dart";


void main(List<String> args) {
  var client = new TraktVmService();
  print("Fetching user data ...");
  var futureUserData = args.map(client.fetchData);
  Future.wait(futureUserData)
    .then((userDataIterable) {
      print("");
      var data = {};
      for (UserData userData in userDataIterable) {
        updateMovies(data, userData.watchlist, WhyChosen.watchlist);
        updateMovies(data, userData.ratings[8], WhyChosen.rating08);
        updateMovies(data, userData.ratings[9], WhyChosen.rating09);
        updateMovies(data, userData.ratings[10], WhyChosen.rating10);
      }

      var thisYear = (new DateTime.now()).year;
      var acceptableMovies = data.values.where(
        (m) => m.numberOfReasons > 1 && m.year <= thisYear)
        .toList();
      acceptableMovies.sort((x, y) => x.compareTo(y) * -1);
      acceptableMovies.forEach((m) => print("${m} [${m.reasonsString()}]"));
      client.close();
      exit(0);
    });

}
