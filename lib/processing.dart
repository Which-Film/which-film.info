library which_film.main;

import 'package:logging/logging.dart';

import "package:which_film/data_search.dart";
import "package:which_film/data_service/common.dart";

/// Common code for driving both the VM and web apps.
List<Movie> processMovies(Iterable<UserData> userDataIterable) {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.message}');
  });

  var data = {};
  for (UserData userData in userDataIterable) {
    if (userData.watchlist == null) {
      Logger.root.severe("empty watchlist for ${userData.username}");
      continue;
    } else if (userData.ratings == null) {
      Logger.root.severe("no ratings for ${userData.username}");
      continue;
    }
    updateMovies(data, userData.watchlist, WhyChosen.watchlist);
    updateMovies(data, userData.ratings[8], WhyChosen.rating08);
    updateMovies(data, userData.ratings[9], WhyChosen.rating09);
    updateMovies(data, userData.ratings[10], WhyChosen.rating10);
    userData.lastWatched.forEach((m, d) {
      if (data.containsKey(m)) {
        var movie = data[m];
        if (movie.lastWatched == null) {
          movie.lastWatched = d;
        } else if (movie.lastWatched.isBefore(d)) {
          movie.lastWatched = d;
        }
      }
    });
  }

  var thisYear = (new DateTime.now()).year;
  var acceptableMovies = data.values
      .where((m) => m.numberOfReasons > 1 && m.year <= thisYear)
      .toList();
  acceptableMovies.sort((x, y) => x.compareTo(y) * -1);
  return acceptableMovies.toList();
}
