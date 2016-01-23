library which_film.data_service;

import "dart:async";
import "dart:convert";

import "package:which-film/data_search.dart";


class UserData {
  Set<Movie> watchlist;
  Map<int, Set<Movie>> ratings;
  Map<Movie, DateTime> lastWatched;

  UserData(this.watchlist, this.ratings, this.lastWatched) {
    // Guarantee that there is a set for every possible rating to avoid other
    // code needing to check if a rating key exists.
    for (var x = 1; x <= 10; x++) {
      ratings.putIfAbsent(x, () => new Set());
    }
  }
}


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

  Future<String> fetchLastWatched(String username);

  String watchlistUrl(String username) => "https://api-v2launch.trakt.tv/" +
                                          "users/${username}/watchlist/movies";
  String ratingsUrl(String username) => "https://api-v2launch.trakt.tv/users/" +
                                        "${username}/ratings/movies";
  String lastWatchedUrl(String username) => "https://api-v2launch.trakt.tv/" +
                                            "users/${username}/watched/movies";

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

  Future<Map<int, Set<Movie>>> ratings(String username) async {
    var responseText = await fetchRatings(username);
    // TODO: check if response succeeded.
    var jsonData = JSON.decode(responseText);
    var ratings = new Map<int, Set<Movie>>();
    for (var ratingData in jsonData) {
      var rating = ratingData["rating"];
      var movie = _makeMovie(ratingData["movie"]);
      ratings.putIfAbsent(rating, () => new Set()).add(movie);
    }

    return ratings;
  }

  Future<Map<Movie, DateTime>> lastWatched(String username) async {
    var responseText = await fetchLastWatched(username);
    // TODO: check if response succeeded.
    var jsonData = JSON.decode(responseText);
    var lastWatchedMap = new Map<Movie, DateTime>();
    for (var lastWatchedData in jsonData) {
      var lastWatched = DateTime.parse(lastWatchedData["last_watched_at"]);
      var movie = _makeMovie(lastWatchedData["movie"]);
      lastWatchedMap[movie] = lastWatched;
    }

    return lastWatchedMap;
  }

  Future<UserData> fetchData(String username) async {
    // It would be more optimal to fan-out all of these calls individually
    // and then fan-in so that e.g., if you are making requests for two
    // people then you are making 6 concurrent requests instead only two
    // at a time. Trick is reconciling the responses back to users
    // (although maybe that isn't important in the end?).
    var watchlistData = await watchlist(username);
    var ratingsData = await ratings(username);
    var lastWatchedData = await lastWatched(username);

    return new UserData(watchlistData, ratingsData, lastWatchedData);
  }
}
