// pub run test test/data_search_test.dart

import "package:test/test.dart";
import "package:which-film/data_search.dart";

void main() {
  group("Movies", () {
    var movie1 = new Movie("A", 2015, "url");
    var movie2 = new Movie("A", 2015, "url");
    var movie3 = new Movie("A", 1000, "url");
    var movie4 = new Movie("B", 2015, "url");

    test("equality", () {
      expect(movie1, equals(movie2));
      expect(movie1, isNot(equals(movie3)));
      expect(movie1, isNot(equals(movie4)));
    });

    test("hashing", () {
      var testSet = new Set()
        ..add(movie1);

      expect(testSet, contains(movie2));
      expect(testSet, isNot(contains(movie3)));
      expect(testSet, isNot(contains(movie4)));
    });
  });

  group("ChosenMovie", () {
    test("hashing/equality same as Movie", () {
      var plainMovie = new Movie("A", 2015, "url");
      var chosenMovie = new ChosenMovie.fromMovie(plainMovie);
      expect(chosenMovie, equals(plainMovie));

      var container = new Set()
        ..add(chosenMovie);
      expect(container, contains(plainMovie));
    });

    test("addReason()/score", () {
      var movie = new ChosenMovie("A", 2015, "url");
      expect(movie.score, equals(0));
      expect(movie.numberOfReasons, equals(0));

      movie.addReason(WhyChosen.rating08);
      expect(movie.score, equals(WhyChosen.rating08.index));
      expect(movie.numberOfReasons, equals(1));
      expect(movie.reasonCount[WhyChosen.rating08], equals(1));

      movie.addReason(WhyChosen.rating09);
      expect(movie.score,
        equals(WhyChosen.rating08.index + WhyChosen.rating09.index));
      expect(movie.numberOfReasons, equals(2));
      expect(movie.reasonCount, hasLength(2));
      expect(movie.reasonCount[WhyChosen.rating08], equals(1));
      expect(movie.reasonCount[WhyChosen.rating09], equals(1));

      movie.addReason(WhyChosen.rating09);
      expect(movie.numberOfReasons, equals(3));
      expect(movie.reasonCount[WhyChosen.rating08], equals(1));
      expect(movie.reasonCount[WhyChosen.rating09], equals(2));

      var rating8Movie = new ChosenMovie("A", 2015, "url");
      rating8Movie.addReason(WhyChosen.rating08);
      var watchlistMovie = new ChosenMovie("B", 2015, "url");
      watchlistMovie.addReason(WhyChosen.watchlist);
      expect(watchlistMovie.score, greaterThan(rating8Movie.score));
    });

    test("compareTo()", () {
      var movie = new ChosenMovie("A", 2015, "url");
      movie.addReason(WhyChosen.rating09);
      var lesserMovie = new ChosenMovie("B", 2015, "url");
      lesserMovie.addReason(WhyChosen.rating08);
      var equalMovie = new ChosenMovie("C", 2015, "url");
      equalMovie.addReason(WhyChosen.rating09);

      expect(movie.compareTo(lesserMovie), equals(1));
      expect(lesserMovie.compareTo(movie), equals(-1));
      expect(movie.compareTo(equalMovie), equals(0));

      var neverWatched = new ChosenMovie("A", 2015, "url");
      var watchedToday = new ChosenMovie.fromMovie(neverWatched);
      watchedToday.lastWatched = new DateTime.now();
      var watchedYesterday = new ChosenMovie.fromMovie(watchedToday);
      watchedYesterday.lastWatched =
        watchedToday.lastWatched.subtract(new Duration(days: 1));

      expect(neverWatched.score, equals(watchedToday.score));
      expect(watchedToday.compareTo(neverWatched), equals(-1));
      expect(neverWatched.compareTo(watchedToday), equals(1));

      expect(watchedToday.score, equals(watchedYesterday.score));
      expect(watchedToday.compareTo(watchedYesterday), equals(-1));
      expect(watchedYesterday.compareTo(watchedToday), equals(1));
    });

    test("reasonsString()", () {
      var movie = new ChosenMovie("A", 2015, "url");
      movie.addReason(WhyChosen.watchlist);
      expect(movie.reasonsString(), contains("watchlist"));

      movie.addReason(WhyChosen.rating10);
      expect(movie.reasonsString(), contains("ten"));

      movie.addReason(WhyChosen.rating09);
      expect(movie.reasonsString(), contains("nine"));

      movie.addReason(WhyChosen.rating08);
      expect(movie.reasonsString(), contains("eight"));

      movie.lastWatched = new DateTime(2016, 1, 2);
      expect(movie.reasonsString(), contains("2016-01-02"));
    });
  });

  test("updateMovies()", () {
    var movie1 = new Movie("1", 2015, "url");
    var movie2 = new Movie("2", 2015, "url");
    var movie3 = new Movie("3", 2015, "url");
    var processed = new Map();

    updateMovies(processed, [movie1, movie2], WhyChosen.rating10);
    expect(processed, contains(movie1));
    expect(processed, contains(movie2));
    processed.values.forEach(
      (v) => expect(v.score, equals(WhyChosen.rating10.index)));

    updateMovies(processed, [movie3], WhyChosen.watchlist);
    expect(processed, contains(movie3));
    expect(processed[movie3].score, equals(WhyChosen.watchlist.index));

    updateMovies(processed, [movie1, movie2], WhyChosen.rating08);
    processed.values.forEach(
      (m) => expect(m.score, equals(WhyChosen.watchlist.index)));
  });
}
