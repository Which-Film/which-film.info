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

  group("combinations", () {
    test("for two items", () {
        var options = new Set.from(["A", "B"]);
        var got = combinations(options.toSet(), 2).toSet();
        var want = new Set()
          ..add(new Set.from(["A", "B"]));
        expect(got, equals(want));
    });

    test("for three items", () {
      var options = new Set.from(["A", "B", "C"]);
      var got = combinations(options, 3).toSet();
      var want = new Set()
        ..add(new Set.from(["A", "B", "C"]));
      expect(got, equals(want));

      got = combinations(options, 2).toSet();
      want = new Set()
        ..add(new Set.from(["A", "B"]))
        ..add(new Set.from(["A", "C"]))
        ..add(new Set.from(["B", "C"]));
      expect(got, equals(want));
    });

    test("for four items", () {
      var options = new Set.from(["A", "B", "C", "D"]);
      var got = combinations(options, 4).toSet();
      var want = new Set()
        ..add(new Set.from(["A", "B", "C", "D"]));
      expect(got, equals(want));

      got = combinations(options, 3).toSet();
      want = new Set()
        ..add(new Set.from(["A", "B", "C"]))
        ..add(new Set.from(["A", "B", "D"]))
        ..add(new Set.from(["A", "C", "D"]))
        ..add(new Set.from(["B", "C", "D"]));
      expect(got, equals(want));

      got = combinations(options, 2).toSet();
      want = new Set()
        ..add(new Set.from(["A", "B"]))
        ..add(new Set.from(["A", "C"]))
        ..add(new Set.from(["A", "D"]))
        ..add(new Set.from(["B", "C"]))
        ..add(new Set.from(["B", "D"]))
        ..add(new Set.from(["C", "D"]));
      expect(got, equals(want));
    });
  });

  group("findMovies()", () {
    var socialNetwork = new Movie(
      "The Social Network",
      2010,
      "https://trakt.tv/movies/the-social-network-2010"
    );
    var inception = new Movie(
      "Inception",
      2010,
      "https://trakt.tv/movies/inception-2010"
    );
    var insideOut = new Movie(
      "Inside Out",
      2015,
      "https://trakt.tv/movies/inside-out-2015"
    );

    test("movie everyone agrees on", () {
      var movieSet = new Set()
        ..add(socialNetwork);
      var people = {"A": movieSet, "B": movieSet, "C": movieSet, "D": movieSet};
      var want = [socialNetwork];
      var got = findMovies(people).toList();

      expect(got, equals(want));
    });

    test("only return movies that match 2 or more people", () {
      var setA = new Set()
        ..add(socialNetwork)
        ..add(inception);
      var setB = new Set()
        ..add(socialNetwork)
        ..add(insideOut);
      var people = {"A": setA, "B": setB};
      var want = [socialNetwork];
      var got = findMovies(people).toList();

      expect(got, equals(want));
    });

    test("start with best matches", () {
      var setA = new Set()
        ..add(socialNetwork)
        ..add(inception);
      var setB = new Set()
        ..add(socialNetwork)
        ..add(inception);
      var setC = new Set()
        ..add(socialNetwork)
        ..add(insideOut);
      var people = {"A": setA, "B": setB, "C": setC};
      var want = [socialNetwork, inception];
      var got = findMovies(people).toList();

      expect(got, equals(want));
    });

    test("skip movies in the future", () {
      var thisYear = new DateTime.now().year;
      var nextYear = thisYear + 1;
      var movie1 = new Movie("title", nextYear, "url");
      var movieSet = new Set()
        ..add(movie1);
      var people = {"A": movieSet, "B": movieSet};
      var got = findMovies(people).toList();

      expect(got, isEmpty);
    });
  });
}
