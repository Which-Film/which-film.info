import "package:which_film/data_search.dart";
import "package:which_film/data_service/common.dart";
import "package:which_film/processing.dart";

import "package:test/test.dart";

void main() {
  group("processMovies()", () {
    var movie1 = new Movie("A", 2015, "url");
    var movie3 = new Movie("A", 1000, "url");
    var movie4 = new Movie("B", 2015, "url");
    var movieFuture =
        new Movie("The Future", (new DateTime.now()).year + 1, "url");

    test("add watchlist data", () {
      var watchlist = new Set()..add(movie1)..add(movie4);
      var userData1 = new UserData("tester", watchlist, new Map(), new Map());
      var userData2 = new UserData("tester2", watchlist, new Map(), new Map());
      var result = processMovies([userData1, userData2]);

      expect(result.length, equals(2));
    });

    test("add ratings == 8", () {
      var ratings = {8: new Set()..add(movie1)..add(movie4)};
      var userData1 = new UserData("tester", new Set(), ratings, new Map());
      var userData2 = new UserData("tester2", new Set(), ratings, new Map());
      var result = processMovies([userData1, userData2]);

      expect(result.length, equals(2));
    });

    test("add ratings == 9", () {
      var ratings = {9: new Set()..add(movie1)..add(movie4)};
      var userData1 = new UserData("tester", new Set(), ratings, new Map());
      var userData2 = new UserData("tester2", new Set(), ratings, new Map());
      var result = processMovies([userData1, userData2]);

      expect(result.length, equals(2));
    });

    test("add ratings == 10", () {
      var ratings = {10: new Set()..add(movie1)..add(movie4)};
      var userData1 = new UserData("tester", new Set(), ratings, new Map());
      var userData2 = new UserData("tester2", new Set(), ratings, new Map());
      var result = processMovies([userData1, userData2]);

      expect(result.length, equals(2));
    });

    test("calculating the last-watched date", () {
      var ratings = {10: new Set()..add(movie1), 9: new Set()..add(movie4)};
      var movie1Date = new DateTime(2015, 7, 1);
      var movie4Date = new DateTime(2015, 8, 1);
      var watched1 = {movie1: movie1Date, movie4: new DateTime(2015, 7, 1)};
      var userData1 = new UserData("tester", new Set(), ratings, watched1);
      var watched2 = {movie1: new DateTime(2015, 6, 1), movie4: movie4Date};
      var userData2 = new UserData("tester2", new Set(), ratings, watched2);
      var result = processMovies([userData1, userData2]);

      expect(result[0].lastWatched, equals(movie1Date));
      expect(result[1].lastWatched, equals(movie4Date));
    });

    test("filter out movies in the future", () {
      var watchlist = new Set()..add(movieFuture)..add(movie4);
      var userData1 = new UserData("tester", watchlist, new Map(), new Map());
      var userData2 = new UserData("tester2", watchlist, new Map(), new Map());
      var result = processMovies([userData1, userData2]);

      expect(result.length, equals(1));
    });

    test("filter out movies with only one reason", () {
      var watchlist1 = new Set()..add(movie1)..add(movie4);
      var userData1 = new UserData("tester", watchlist1, new Map(), new Map());
      var watchlist2 = new Set()..add(movie1)..add(movie3);
      var userData2 = new UserData("tester2", watchlist2, new Map(), new Map());
      var result = processMovies([userData1, userData2]);

      expect(result.length, equals(1));
    });

    test("sorted", () {
      var ratings1 = {10: new Set()..add(movie1), 9: new Set()..add(movie4)};
      var userData1 = new UserData("tester", new Set(), ratings1, new Map());
      var ratings2 = {8: new Set()..add(movie1), 10: new Set()..add(movie4)};
      var userData2 = new UserData("tester2", new Set(), ratings2, new Map());
      var result = processMovies([userData1, userData2]);

      expect(result.length, equals(2));
      expect(result[0], equals(movie4));
      expect(result[1], equals(movie1));
    });
  });
}
