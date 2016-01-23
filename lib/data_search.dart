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
  DateTime lastWatched;

  ChosenMovie(title, year, url): super(title, year, url);

  ChosenMovie.fromMovie(Movie movie): super(movie.title, movie.year, movie.url);

  int get score => _score;
  int get numberOfReasons => _numberOfReasons;

  int compareTo(ChosenMovie other) {
    int order  = _score.compareTo(other.score);
    if (order == 0) {
      if (lastWatched != null) {
        if (other.lastWatched == null) {
          order = -1;
        } else {
          order = lastWatched.compareTo(other.lastWatched) * -1;
        }
      } else if (other.lastWatched != null) {
        order = 1;
      }
    }

    return order;
  }

  void addReason(WhyChosen reason) {
    reasonCount[reason] = reasonCount.putIfAbsent(reason, () => 0) + 1;
    _score += reason.index;
    _numberOfReasons += 1;
  }

  void _reasonStringPart(WhyChosen reason, String name, List<String> parts) {
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
    if (lastWatched != null) {
      var yearString = lastWatched.year.toString();
      var monthString = lastWatched.month.toString().padLeft(2, "0");
      var dayString = lastWatched.day.toString().padLeft(2, "0");
      parts.add("last watched on " +
                "${yearString}-${monthString}-${dayString}");
    }

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
