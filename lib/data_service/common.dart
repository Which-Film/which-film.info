library which_film.data_service;

import "dart:async";
import "dart:convert";

import "package:which-film/data_search.dart";


/// A data service for trakt.tv.
abstract class TraktService {
  static final requestHeaders = {
    "Content-Type": "application/json",
    "trakt-api-version": "2",
    "trakt-api-key": "3b1469ddbeaedc0b1f8dacd8035baea4fddff31fef7441e46e1c7a1c87fe9408"
  };

  /// Abstract network request for a user's watchlist.
  Future<String> fetchWatchlist(String username);

  /// Abstract network request for a user's ratings.
  Future<String> fetchRatings(String username);

  String watchlistUrl(String username) => "https://api-v2launch.trakt.tv/" +
                                          "users/${username}/watchlist/movies";
  String ratingsUrl(String username) => "https://api-v2launch.trakt.tv/users/" +
                                        "${username}/ratings/movies";

  Movie _makeMovie(Map jsonData) {
    var slug = jsonData["ids"]["slug"];
    var url = "https://trakt.tv/movies/${slug}";
    return new Movie(jsonData["title"], jsonData["year"], url);
  }

  Future<Set<Movie>> watchlist(String username) async {
    var responseText = await fetchWatchlist(username);
    // TODO: check response succeeded, handle failures.
    var jsonData = JSON.decode(responseText);
    var movies = new Set<Movie>();
    for (var watchlistData in jsonData) {
      movies.add(_makeMovie(watchlistData["movie"]));
    }

    return movies;
  }

  Future<Map<Movie, int>> ratings(String username) async {
    var responseText = await fetchRatings(username);
    // TODO: check if response succeeded.
    var jsonData = JSON.decode(responseText);
    var ratings = new Map<Movie, int>();
    for (var ratingData in jsonData) {
      var rating = ratingData["rating"];
      var movie = _makeMovie(ratingData["movie"]);
      ratings[movie] = rating;
    }

    return ratings;
  }
}
