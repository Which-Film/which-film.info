library which_film.data_service;

import "dart:async";
import "dart:convert";
import "dart:html";


/// Metadata for a movie.
class Movie {
  final String title;
  final int year;
  final String url;

  const Movie(this.title, this.year, this.url);

  String fullName() {
    return "${title} (${year})";
  }
}


/// Interface for a service the provides a user's movie preferences.
abstract class DataService {
  // Does not provide a way to make authenticated requests for data.

  Future<Set<Movie>> fetchWatchlist(String username);
}


/// An implementation of [DataService] for trakt.tv.
class TraktService implements DataService {
  // TODO: make the trakt API key a constructor argument that Angular somehow
  //       specifies.
  static const String traktApiKey = "XXX";

  Future<Set<Movie>> fetchWatchlist(String username) async {
    var url = "https://api-v2launch.trakt.tv/users/${username}/watchlist/movies";
    var headers = {
      "Content-Type": "application/json",
      "trakt-api-version": "2",
      "trakt-api-key": traktApiKey
    };
    var response = await HttpRequest.request(url, responseType: "json",
                                             requestHeaders: headers);
    // TODO: check response succeeded, handle failures.

    var jsonData = JSON.decode(response.responseText);
    var movies = new Set<Movie>();
    for (var watchlistData in jsonData) {
      var movieData = watchlistData["movie"];
      var slug = movieData["slug"];
      var url = "https://trakt.tv/movies/${slug}";
      movies.add(new Movie(movieData["title"], movieData["year"], url));
    }

    return movies;
  }
}
