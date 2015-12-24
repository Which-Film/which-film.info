/// Metadata for a movie.
class Movie {
  final String title;
  final int year;
  final String url;

  const Movie(this.title, this.year, this.url);

  String toString() => "${title} (${year})";

  bool operator ==(other) {
    return other is Movie && title == other.title && year == other.year;
  }

  int get hashCode => toString().hashCode;
}


/// Reasons why someone would want to watch a film.
enum WhyChosen {
  unused,  // Because Dart won't let you specify the starting index.
  rating08,
  rating09,
  rating10,
  watchlist
}

/// A movie that someone would like to watch.
class ChosenMovie extends Movie implements Comparable {
  int _score = 0;
  int _numberOfReasons = 0;
  final Map<WhyChosen, int> reasonCount = new Map();

  ChosenMovie(title, year, url): super(title, year, url);

  ChosenMovie.fromMovie(Movie movie): super(movie.title, movie.year, movie.url);

  int get score => _score;
  int get numberOfReasons => _numberOfReasons;

  int compareTo(ChosenMovie other) => _score.compareTo(other.score);

  void addReason(WhyChosen reason) {
    reasonCount[reason] = reasonCount.putIfAbsent(reason, () => 0) + 1;
    _score += reason.index;
    _numberOfReasons += 1;
  }

  String _reasonStringPart(WhyChosen reason, String name, List<String> parts) {
    if (reasonCount.containsKey(reason)) {
      parts.add("${name}: ${reasonCount[reason]}");
    }
  }

  String reasonsString() {
    var parts = [];
    _reasonStringPart(WhyChosen.watchlist, "watchlist", parts);
    _reasonStringPart(WhyChosen.rating10, "ten stars", parts);
    _reasonStringPart(WhyChosen.rating09, "nine stars", parts);
    _reasonStringPart(WhyChosen.rating08, "eight stars", parts);

    return parts.join(", ");
  }
}


void updateMovies(Map<Movie, ChosenMovie> chosenMovies,
  Iterable<Movie> newMovies, WhyChosen reason) {
    // If sets allowed for a way to return the actual contained item then
    // a map wouldn't be needed as a ChosenMovie inherits Movie's equality
    // invariant.
    newMovies.forEach((m) {
      var chosenMovie = chosenMovies.putIfAbsent(m,
        () => new ChosenMovie.fromMovie(m));
      chosenMovie.addReason(reason);
    });
  }
